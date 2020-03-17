class CreateUsersClubsRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :users_clubs_roles do |t|
      t.integer :user_id, null: false
      t.integer :club_id, null: false
      t.string :role, null: false
    end
  end
end
