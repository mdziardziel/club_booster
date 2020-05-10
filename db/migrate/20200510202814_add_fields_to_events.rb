class AddFieldsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :end_date, :datetime
    add_column :events, :symbol, :string
  end
end
