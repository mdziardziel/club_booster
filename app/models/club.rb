class Club < ApplicationRecord
  attribute :owner_id

  validates :name, presence: true
  validates :owner_id, presence: true, on: :create


  after_create :nominate_president

  private

  def nominate_president
    UserClub.create!(user_id: owner_id, club_id: id, roles: Role.president)
  end
end
