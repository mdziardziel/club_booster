class Member < ApplicationRecord
  belongs_to :user, inverse_of: :members
  belongs_to :club, inverse_of: :members

  validates :user_id, :club_id, presence: true
end
