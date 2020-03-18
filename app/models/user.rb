class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :email, presence: true
  validates :password, presence: true, on: :create

  has_many :users_clubs, class_name: 'UserClub', inverse_of: :user
  has_many :clubs, through: :users_clubs, inverse_of: :users
  
  TOKEN_EXPIRATION_TIME = 100.years

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    return if user.nil?

    user.valid_password?(password) ? user : nil
  end
  
  def generate_jwt
    return if expire_previous_jwt.blank?

    ::JsonWebToken.encode({ sub: id, ver: jwt_version }, TOKEN_EXPIRATION_TIME.from_now)
  end

  def expire_previous_jwt
    self.jwt_version = jwt_version + 1
    update(jwt_version: jwt_version)
  end
end
