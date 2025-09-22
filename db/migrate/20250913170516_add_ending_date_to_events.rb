class AddEndingDateToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :ending_date, :datetime, null: false
  end
end
