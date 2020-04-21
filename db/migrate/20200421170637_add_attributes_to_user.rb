class AddAttributesToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :surname, :string
    add_column :users, :birth_date, :datetime
    add_column :users, :personal_description, :text
    add_column :users, :career_description, :text
    add_column :users, :avatar_url, :string
  end
end
