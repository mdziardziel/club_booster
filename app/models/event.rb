class Event < ApplicationRecord
  belongs_to :club, inverse_of: :events

  validates :club_id, :name, :start_date, presence: true
end
