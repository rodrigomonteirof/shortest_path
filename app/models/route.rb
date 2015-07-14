class Route < ActiveRecord::Base
  belongs_to :map
  validates :map, :origin, :destiny, presence: true
  validates :distance, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
