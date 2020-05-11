class EventsController < ApiAuthorizedController
  def index
    render json: current_user.events, each_serializer: EventSerializer
  end

  def show
    render json: current_user.event(params[:id]), serializer: EventSerializer
  end
end
