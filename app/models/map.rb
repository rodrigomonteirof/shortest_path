class Map < ActiveRecord::Base
  has_many :routes
  validates :name, presence: true, uniqueness: true

  def find_routes(origin)
    routes.select { |r| r.origin == origin }
  end

  def load_routes(map_routes)
    return unless map_routes.present?

    map_routes.each do |route|
      data = route.split(' ')

      routes << Route.new(
        origin: data[0],
        destiny: data[1],
        distance: data[2]
      )
    end
  end
end
