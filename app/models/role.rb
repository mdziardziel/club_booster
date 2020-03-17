class Role
  AVAILABLE_ROLES = %w(PRESIDENT COACH PLAYER)

  # class << self
  #   AVAILABLE_ROLES.each do |role|
  #     define_method role.downcase
  #   end
  # end
end