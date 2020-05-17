class MemberSerializer < ActiveModel::Serializer
  attributes :roles, :club_id, :user_id, :id, :name, :surname, :approved, :avatar_url, :description, :career, :birth_date, :can_remove

  def name
    user.name
  end

  def surname
    user.surname
  end

  def avatar_url
    user.avatar_url
  end

  def description
    user.personal_description
  end

  def career
    user.career_description
  end

  def birth_date
    user.birth_date&.to_date
  end

  def can_remove
    return false if object.id == current_member.id

    Role.can_manage?(current_member.roles, object.roles)
  end

  private

  def user 
    @user ||= object.user
  end

  def current_member
    @current_member ||= instance_options[:current_member]
  end
end
