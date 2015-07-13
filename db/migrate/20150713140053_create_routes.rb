class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.belongs_to :map, index: true
      t.string :origin
      t.string :destiny
      t.integer :distance

      t.timestamps null: false
    end
    add_foreign_key :routes, :maps
  end
end
