class ApiAuthorizedController < ApplicationController
  include AuthorizeActionsHelper
  include CreationHelper

  before_action :authenticate_user!

  private

  def member
    @member ||= Member.find_by(user_id: current_user.id, club_id: params[:club_id])
  end
end
