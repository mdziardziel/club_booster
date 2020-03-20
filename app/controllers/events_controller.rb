class EventsController < ApiAuthorizedController
  before_action :authorize_only_club_members
  before_action :authorize_only_members_with_president_or_coach_role, only: %i(create)

  def create
    save_and_render_json
  end

  private

  def creation_params
    prms = event_creation_params.slice(:name)
    prms[:club_id] = member.club_id
    prms[:participants] = event_members_ids.each_with_object({}) { |id, hsh| hsh[id] = nil }
    prms[:start_date] = Time.at(event_creation_params[:start_date].to_i)
    prms
  end

  def event_creation_params
    @event_creation_params ||= 
      params.require(:event).permit(:name, :start_date, groups_ids: [], members_ids: [])
  end

  def event_members_ids
    participants_ids = []
    groups = Group.where(club_id: member.club_id, id: event_creation_params[:groups_ids])
    groups.each { |group| participants_ids = participants_ids + group.members_ids }
    members_ids = Member.where(club_id: member.club_id, id: event_creation_params[:members_ids]).pluck(:id)
    (participants_ids + members_ids).uniq
  end
end