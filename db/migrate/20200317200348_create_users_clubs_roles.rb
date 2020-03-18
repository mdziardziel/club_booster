class CreateUsersClubsRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :users_clubs do |t|
      t.integer :user_id, null: false
      t.integer :club_id, null: false
      t.string :roles, default: ''
      t.references :user, index: true
      t.references :club, index: true
      t.index [:user_id, :club_id]
    end
  end
end
