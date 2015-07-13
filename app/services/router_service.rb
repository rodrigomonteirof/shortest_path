class RouterService
  def initialize(map)
    @map = map
    @pending_routes = {}
    @found_better = false
  end

  def shortest_path(origin, destiny)
    load_default(origin)

    while @found_better == false
      place = best_route

      @found_better = place[1][:destiny] == destiny

      merge_with_children(place)

      delete_route(best_route)
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

  def add_route(route)
    @pending_routes["#{route.origin}-#{route.destiny}"] = {
      distance: route.distance,
      alias: "#{route.origin}-#{route.destiny}",
      origin: route.origin,
      destiny: route.destiny
    }
  end

  def add_route_merge(parent, route)
    @pending_routes["#{parent[:alias]}-#{route.destiny}"] = {
      distance: parent[:distance] + route.distance,
      alias: "#{parent[:alias]}-#{route.destiny}",
      origin: route.origin,
      destiny: route.destiny
    }
  end

  def best_route
    @pending_routes.sort_by { |_k, v| v[:distance] }.first
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

  def merge_with_children(place)
    parent = @pending_routes[place[0]]

    @map.find_routes(place[1][:destiny]).each do |route|
      add_route_merge(parent, route)
    end
  end
end
