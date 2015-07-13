class Map < ActiveRecord::Base
  has_many :routes

  def find_routes(origin)
    routes.select{ |r| r.origin == origin }
  end
end
