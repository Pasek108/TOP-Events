class ChangeLocationInEvents < ActiveRecord::Migration[8.0]
  def change
    remove_column :events, :location, :string
    add_column :events, :latitude, :float, null: false
    add_column :events, :longitude, :float, null: false
    add_column :events, :location_name, :string, null: false
  end
end
