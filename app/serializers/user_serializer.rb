class UserSerializer < ActiveModel::Serializer
  attributes :age, :name, :surname, :birth_date, :personal_description, :career_description, :email, :avatar_url

  def birth_date
    object.birth_date&.to_date  
  end

  def age
    return nil if  object.birth_date.nil?
    
    ((Time.zone.now - object.birth_date.to_time) / 1.year.seconds).floor
  end
end
