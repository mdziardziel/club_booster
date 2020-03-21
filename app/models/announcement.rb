class Announcement < ApplicationRecord
  belongs_to :club, inverse_of: :announcements

  validates :club_id, :content, presence: true
end
