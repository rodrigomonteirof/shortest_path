class MapsController < ApplicationController
  before_action :set_values, only: [:best_route]
  skip_before_action :verify_authenticity_token

  # curl --data "name=SP&routes[]=A B 10&routes[]=B D 15&routes[]=A C 20&routes[]=C D 30&routes[]=B E 50&routes[]=D E 30" http://localhost:3000/maps
  def create
    @map = Map.find_or_create_by(name: map_params['name'])
    @map.load_routes(map_params['routes'])

    if @map.save
      render(json: { map: @map, routes: @map.routes })
    else
      render(json: { map: @map.errors })
    end
  end

  # curl -isS "localhost:3000/bestroute/SP/A/D/9.5/250"
  def best_route
    router = RouterService.new(@map)
    route = router.shortest_path(params['origin'], params['destiny'])

    if route.present?
      render(json: router.response(route, @autonomy, @price))
    else
      render(json: 'Not found any route')
    end
  end

  private

  def set_values
    @map = Map.find_by(name: map_params[:name])
    @autonomy = params['autonomy']
    @price = params['price']
  end

  def map_params
    params.permit(:name, routes: [])
  end
end
