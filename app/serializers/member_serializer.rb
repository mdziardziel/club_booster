class MemberSerializer < ActiveModel::Serializer
  attributes :roles, :club_id, :user_id, :id, :name, :surname, :approved, :avatar_url

  def name
    object.user.name
  end

  def surname
    object.user.surname
  end

  def avatar_url
    object.user.avatar_url
  end
end
