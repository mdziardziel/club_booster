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
    render json: { message: "You are not authorized to perform this action", data: {}, errors: {}}, status: 403
  end

  def authorize_only_president_or_coach_role
    authorize_only_club_members
    
    raise NotAuthorizedError unless club_member.has_president_role? || club_member.has_coach_role?
  end

  def authorize_only_club_members
    raise NotAuthorizedError if club_member.blank?
  end

  def club_member
    raise NotImplementedError
  end
end