class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :date, null: false
      t.string :location, null: false

      t.timestamps
    end
  end
end
