class RouterService
  def initialize(map)
    @map = map
    @pending_routes = {}
    @found_better = false
  end

  def shortest_path(origin, destiny)
    load_default(origin)

    best_route(origin, destiny)
  rescue StandardError => e
    Rails.logger.info("Error to search shortest path: #{e.message}")
    nil
  end

  def response(route, autonomy, price)
    I18n.translate('response', route: route[0], price: total_cost(route[1][:distance], autonomy, price))
  end

  private

  def add_routes(routes)
    routes.each do |route|
      add_route(route)
    end
  end

  def add_route(route, parent = nil)
    @pending_routes[merge_name(route, parent)] = {
      distance: sum_distance(route, parent),
      alias: merge_name(route, parent),
      origin: route.origin,
      destiny: route.destiny
    }
  end

  def best_route(origin, destiny)
    # get shortest path between available routes
    route = @pending_routes.sort_by { |_k, v| v[:distance] }.first

    fail StandardError, 'Not found any route' unless route.present?

    # if has a loop discart route and back to start
    if loop?(route, origin)
      delete_route(route)
      route = best_route(origin, destiny)
    end

    # merge route with all children
    # example: (A-B) with (C) adds (A-B-C and A-B-E) routes
    merge_with_children(route)

    # delete route parent
    delete_route(route)

    # if it is not in destiny, it backs to start
    route = best_route(origin, destiny) if route[1][:destiny] != destiny

    route
  end

  def loop?(place, origin)
    place[1][:destiny] == origin ||
      place[0].split('-')[0...-1].include?(place[1][:destiny])
  end

  def delete_route(route)
    @pending_routes.delete(route[0])
  end

  def load_default(origin)
    @pending_routes = {}
    @found_better = false

    routes = @map.find_routes(origin)
    fail StandardError, 'No routes for this map' if routes.empty?

    add_routes(routes)
    routes
  end

  def merge_name(route, parent = nil)
    if parent.present?
      "#{parent[:alias]}-#{route.destiny}"
    else
      "#{route.origin}-#{route.destiny}"
    end
  end

  def merge_with_children(place)
    parent = @pending_routes[place[0]]

    @map.find_routes(place[1][:destiny]).each do |route|
      add_route(route, parent)
    end
  end

  def sum_distance(route, parent = nil)
    if parent.present?
      parent[:distance] + route.distance
    else
      route.distance
    end
  end

  def total_cost(distance, autonomy, price)
    (distance / autonomy.to_f) * Money.new(price)
  end
end
