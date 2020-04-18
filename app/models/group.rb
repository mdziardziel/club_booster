class Group < ApplicationRecord
  belongs_to :club, inverse_of: :groups

  validates :club_id, presence: { message: I18nForPerson.t('errors.messages.blank', :male) }
  validates :name, presence: { message: I18nForPerson.t('errors.messages.blank', :neuter) }
end
