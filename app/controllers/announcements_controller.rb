class AnnouncementsController < ApiAuthorizedController
  def index
    render json: current_user.announcements
  end

  def show
    render json: current_user.announcement(params[:id])
  end
end
