class RouterService
  def initialize(map)
    @map = map
    @pending_routes = {}
    @found_better = false
  end

  def shortest_path(origin, destiny)
    routes = @map.find_routes(origin)
    add_routes(routes)

    while @found_better == false do
      place = best_route

      @found_better = place[1][:destiny] == destiny

      merge_with_children(place)
      delete_route(best_route)
    end

   @pending_routes = {}
   @found_better = false

   puts "The best route is #{place[0]} with #{place[1][:distance]}"
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
      destiny: route.destiny,
      id: route.id
    }
  end

  def add_route_merge(parent, route)
     @pending_routes["#{parent[:alias]}-#{route.destiny}"] = {
      distance: parent[:distance] + route.distance,
      alias: "#{parent[:alias]}-#{route.destiny}",
      origin: route.origin,
      destiny: route.destiny,
      id: route.id
    }
  end

  def best_route
    @pending_routes.sort_by{ |k,v| v[:distance] }.first
  end

  def delete_route(route)
    @pending_routes.delete(route[0])
  end

  def merge_with_children(place)
    parent = @pending_routes[place[0]]

    @map.find_routes(place[1][:destiny]).each do |route|
      add_route_merge(parent, route)
    end
  end
end
