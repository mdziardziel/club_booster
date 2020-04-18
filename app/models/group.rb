class Group < ApplicationRecord
  belongs_to :club, inverse_of: :groups

  validates :club_id, presence: { message: trans('errors.messages.blank', :male) }
  validates :name, presence: { message: trans('errors.messages.blank', :neuter) }
end
