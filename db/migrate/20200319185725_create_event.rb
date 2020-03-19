class CreateEvent < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.datetime  :start_date, null: false 
      t.jsonb :participants, default: {}
      t.integer :club_id, null: false 
      t.references :club, index: true
    end
  end
end
