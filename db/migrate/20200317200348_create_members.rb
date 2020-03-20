class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.integer :user_id, null: false
      t.integer :club_id, null: false
      t.string :roles, array: true, default: []
      t.boolean :approved, default: false
      t.references :user, index: true
      t.references :club, index: true
      t.index [:user_id, :club_id]
    end
  end
end
