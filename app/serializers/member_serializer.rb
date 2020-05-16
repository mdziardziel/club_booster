class MemberSerializer < ActiveModel::Serializer
  attributes :roles, :club_id, :user_id, :id, :name, :surname, :approved

  def name
    object.user.name
  end

  def surname
    object.user.surname
  end
end
