module Clubs
  class EventsController < ApiAuthorizedController
    include ClubMember
    include CreationHelper
  
    before_action :authorize_only_club_members
    before_action :authorize_only_president_or_coach_role, only: %i(create)
  
    def index
      render json: club_member.events, each_serializer: EventSerializer
    end
  
    def show
      render json: club_member.event(params[:id]), serializer: EventSerializer
    end
  
    def create
      save_and_render_json
    end

    def presence
      if event.check_presence(club_member.id, params[:presence])
        render json: { message: "#{params[:presence] ? 'Presence' : 'Absence'} approved", data: event, errors: {}}, status: 201
      else
        render json: { message: "#{params[:presence] ? 'Presence' : 'Absence'} not approved", data: event, errors: event.errors.messages }, status: 422
      end
    end
  
    private

    def event
      @event ||= club_member.event(params[:event_id])
    end
  
    def creation_params
      prms = event_creation_params.slice(:name, :symbol)
      prms[:club_id] = params[:club_id]
      prms[:participants] = event_members_ids.each_with_object({}) { |id, hsh| hsh[id] = nil }
      prms[:start_date] = Time.at(event_creation_params[:start_date].to_i)
      prms[:end_date] = Time.at(event_creation_params[:end_date].to_i) if event_creation_params[:end_date].present?
      prms
    end
  
    def event_creation_params
      @event_creation_params ||= 
        params.require(:event).permit(:name, :start_date, :symbol, :end_date, groups_ids: [], members_ids: [])
    end
  
    def event_members_ids
      participants_ids = []
      groups = Group.where(club_id: params[:club_id], id: event_creation_params[:groups_ids])
      groups.each { |group| participants_ids = participants_ids + group.members_ids }
      members_ids = Member.where(club_id: params[:club_id], id: event_creation_params[:members_ids]).pluck(:id)
      (participants_ids + members_ids).uniq
    end
  end
end