class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  TOKEN_EXPIRATION_TIME = 100.years

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user.valid_password?(password) ? user : nil
  end
  
  def generate_jwt
    return if expire_previous_jwt.blank?

    ::JsonWebToken.encode({ sub: id, ver: jwt_version }, TOKEN_EXPIRATION_TIME.from_now)
  end

  def expire_previous_jwt
    update(jwt_version: jwt_version + 1)
  end
end
