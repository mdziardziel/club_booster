class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable
  
  validates :email, presence: true
  validates :password, presence: true, on: :create

  has_many :members, inverse_of: :user
  has_many :clubs, through: :members, inverse_of: :users
  
  TOKEN_EXPIRATION_TIME = 100.years

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    return if user.nil?

    user.valid_password?(password) ? user : nil
  end
  
  def generate_jwt
    return if expire_previous_jwt.blank?

    ::JsonWebToken.encode({ sub: id, ver: jwt_version }, TOKEN_EXPIRATION_TIME.from_now)
  end

  def expire_previous_jwt
    self.jwt_version = jwt_version + 1
    update(jwt_version: jwt_version)
  end

  def events
    clubs_ids = clubs.pluck(:id)
    Event.where(club_id: clubs_ids).filter do |event|
      ids = event.participants.keys
      member_id = Member.find_by(club_id: event.club_id, user_id: id).id
      ids.include?(member_id.to_s)
    end
  end

  def event(event_id)
    clubs_ids = clubs.pluck(:id)
    event = Event.find_by(id: event_id, club_id: clubs_ids)
    return if event.nil?

    member = Member.find_by(club_id: event.club_id, user_id: id)
    return if member.nil? || event.participants.keys.exclude?(member.id.to_s)

     event
  end

  def announcements
    clubs_ids = clubs.pluck(:id)
    Announcement.where(club_id: clubs_ids).filter do |event|
      member_id = Member.find_by(club_id: event.club_id, user_id: id).id
      event.members_ids.include?(member_id)
    end
  end

  def announcement(ann_id)
    clubs_ids = clubs.pluck(:id)
    ann = Announcement.find_by(id: ann_id, club_id: clubs_ids)
    return if ann.nil?

    member = Member.find_by(club_id: ann.club_id, user_id: id)
    return if member.nil? || ann.members_ids.exclude?(member.id)

     ann
  end
end
