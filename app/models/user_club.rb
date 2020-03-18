class UserClub < ApplicationRecord
  self.table_name = 'users_clubs'

  belongs_to :user, inverse_of: :users_clubs
  belongs_to :club, inverse_of: :users_clubs

  validates :user_id, :club_id, presence: true
end
