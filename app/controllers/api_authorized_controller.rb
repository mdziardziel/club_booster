class ApiAuthorizedController < ApplicationController
  before_action :authenticate_user!

  class NotAuthorizedError < StandardError
    def message
      "User is not authorized to perform this action"
    end
  end

  rescue_from NotAuthorizedError, with: :not_authorized

  private 

  def not_authorized
    render json: { message: "You are not authorized to perform this action", data: {}, errors: {}}, status: 401
  end
end
