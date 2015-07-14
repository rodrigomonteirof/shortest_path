class RouterService
  def initialize(map)
    @map = map
    @pending_routes = {}
    @found_better = false
  end

  def shortest_path(origin, destiny)
    load_default(origin)

    while @found_better == false
      place = best_route(origin)

      @found_better = place[1][:destiny] == destiny

      merge_with_children(place)

      delete_route(place)
    end

    place
  rescue StandardError => e
    Rails.logger.info("Error to search shortest path: #{e.message}")
    nil
  end

  private

  def add_routes(routes)
    routes.each do |route|
      add_route(route)
    end
  end

  def add_route(route, parent = nil)
    @pending_routes[merge_name(route,parent)] = {
      distance: sum_distance(route, parent),
      alias: merge_name(route,parent),
      origin: route.origin,
      destiny: route.destiny
    }
  end

  def best_route(origin)
    route = @pending_routes.sort_by { |_k, v| v[:distance] }.first

    fail StandardError, 'Not found any route' unless route.present?

    if loop?(route, origin)
      delete_route(route)

      # Recursivity for get best route
      route = best_route(origin)
    end

    route
  end

  def loop?(place, origin)
    place[1][:destiny] == origin
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
      name = "#{parent[:alias]}-#{route.destiny}"
    else
      name = "#{route.origin}-#{route.destiny}"
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
end
