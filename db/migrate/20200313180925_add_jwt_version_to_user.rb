class AddJwtVersionToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :jwt_version, :integer, default: 0, null: false
  end
end
