class UserSerializer < ActiveModel::Serializer
  attributes :name, :surname, :birth_date, :personal_description, :career_description, :email, :avatar_url

  def birth_date
    object.birth_date&.to_date  
  end
end
