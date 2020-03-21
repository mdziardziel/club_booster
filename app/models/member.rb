class Member < ApplicationRecord
  belongs_to :user, inverse_of: :members
  belongs_to :club, inverse_of: :members

  validates :user_id, :club_id, presence: true
  validates :user_id, uniqueness: { scope: :club_id, message: 'one user per club available' }

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

  def announcements
    Announcement.where(club_id: club_id).filter do |event|
      event.members_ids.include?(id)
    end
  end

  def announcement(ann_id)
    ann = Announcement.find_by(id: ann_id, club_id: club_id)
    return if ann.nil? || ann.members_ids.exclude?(id)

     ann
  end
end
