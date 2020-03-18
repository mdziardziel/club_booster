class Club < ApplicationRecord
  attribute :owner_id

  validates :name, presence: true
  validates :owner_id, presence: true, on: :create

  has_many :users_clubs,  class_name: 'UserClub', inverse_of: :club
  has_many :users, through: :users_clubs, inverse_of: :clubs

  after_create :nominate_president

  private

  def nominate_president
    UserClub.create!(user_id: owner_id, club_id: id, roles: Role.president)
  end
end
