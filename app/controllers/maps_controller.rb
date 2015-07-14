class MapsController < ApplicationController
  before_action :set_map, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    @maps = Map.all
    render(json: { map: @maps })
  end

  def create
    @map = Map.new(name: map_params['name'])
    @map.load_routes(map_params['routes'])

    if @map.save
      render(json: { map: @map, routes: @map.routes })
    else
      render(json: { map: @map.errors })
    end
  end

  private

  def set_map
    @map = Map.find(params[:id])
  end

  def map_params
    params.permit(:name, routes: [])
  end
end
