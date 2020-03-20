class Member < ApplicationRecord
  belongs_to :user, inverse_of: :members
  belongs_to :club, inverse_of: :members

  validates :user_id, :club_id, presence: true

  Role::AVAILABLE_ROLES.each do |role|
    define_method("has_#{role.downcase}_role?") { roles.include?(role) }
  end
end
