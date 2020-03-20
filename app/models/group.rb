class Group < ApplicationRecord
  belongs_to :club, inverse_of: :groups

  validates :club_id, :name, presence: true
end
