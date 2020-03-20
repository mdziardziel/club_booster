class Member < ApplicationRecord
  belongs_to :user, inverse_of: :members
  belongs_to :club, inverse_of: :members

  validates :user_id, :club_id, presence: true

  Role::AVAILABLE_ROLES.each do |role|
    define_method("has_#{role.downcase}_role?") { roles.include?(role) }
  end

  def events
    Event.where(club_id: club_id).filter do |event|
      ids = event.participants.keys
      ids.include?(id.to_s)
    end
  end

  def event(event_id)
    event = Event.find_by(id: event_id, club_id: club_id)
    return if event.nil? || event.participants.keys.exclude?(id.to_s)

     event
  end
end
