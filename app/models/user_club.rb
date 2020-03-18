class UserClub < ApplicationRecord
  self.table_name = 'users_clubs'

  validates :user_id, :club_id, presence: true
end
