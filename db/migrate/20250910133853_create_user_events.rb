class CreateUserEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :user_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :role, null: false

      t.timestamps
    end
  end
end
