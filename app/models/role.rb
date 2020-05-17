class Role
  PRESIDENT = 'PRESIDENT'.freeze
  COACH = 'COACH'.freeze
  PLAYER = 'PLAYER'.freeze
  AVAILABLE_ROLES = %w(PRESIDENT COACH PLAYER)

  class << self
    AVAILABLE_ROLES.each do |role|
      define_method(role.downcase) { role }
    end
  end

  def self.can_manage?(manager_roles, managed_roles)
    return true if manager_roles.include?(PRESIDENT) && managed_roles.exclude?(PRESIDENT)
    return true if manager_roles.include?(COACH) && managed_roles.exclude?(PRESIDENT) && managed_roles.exclude?(COACH)

    false
  end
end