module AuthorizeActionsHelper
  extend ActiveSupport::Concern

  class NotAuthorizedError < StandardError
    def message
      "User is not authorized to perform this action"
    end
  end

  included do
    rescue_from NotAuthorizedError, with: :not_authorized
  end

  private 

  def not_authorized
    render json: { message: "You are not authorized to perform this action", data: {}, errors: {}}, status: 401
  end

  def authorize_only_members_with_president_or_coach_role
    raise NotAuthorizedError unless member.has_president_role? || member.has_coach_role?
  end

  def authorize_only_club_members
    raise NotAuthorizedError if member.blank?
  end

  def member
    raise NotImplementedError
  end
end