class Announcement < ApplicationRecord
  belongs_to :club, inverse_of: :announcements

  validates :club_id, presence: { message: I18nForPerson.t('errors.messages.blank', :male) }
  validates :content, presence: { message: I18nForPerson.t('errors.messages.blank', :female) }

end
