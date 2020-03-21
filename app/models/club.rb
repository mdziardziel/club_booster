class Club < ApplicationRecord
  BASE_64_FORCE = 12

  attribute :owner_id

  validates :name, presence: true
  validates :owner_id, presence: true, on: :create

  has_many :members, inverse_of: :club
  has_many :users, through: :members, inverse_of: :clubs
  has_many :events, inverse_of: :club
  has_many :groups, inverse_of: :club
  has_many :announcements, inverse_of: :club

  after_create :nominate_president
  before_create :generate_token

  private

  def nominate_president
    Member.create!(user_id: owner_id, club_id: id, roles: [Role.president], approved: true)
  end

  def generate_token
    self.token = SecureRandom.base64(BASE_64_FORCE)
  end
end
