class Announcement < ApplicationRecord
  belongs_to :club, inverse_of: :announcements

  validates :club_id, presence: { message: trans('errors.messages.blank', :male) }
  validates :content, presence: { message: trans('errors.messages.blank', :female) }

end
