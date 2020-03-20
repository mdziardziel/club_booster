class EventsController < ApiAuthorizedController
  def index
    render json: current_user.events
  end

  def show
    render json: current_user.event(params[:id])
  end
end
