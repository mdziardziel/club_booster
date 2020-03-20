class CreateGroup < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.integer :members_ids, array: true, default: []
      t.integer :club_id, null: false
      t.references :club, index: true
    end
  end
end
