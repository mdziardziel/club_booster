module Clubs
  class AnnouncementsController < ApiAuthorizedController
    include ClubMember
    include CreationHelper
  
    before_action :authorize_only_club_members
    before_action :authorize_only_president_or_coach_role, only: %i(create)
  
    def index
      render json: club_member.announcements
    end
  
    def show
      render json: club_member.announcement(params[:id])
    end
  
    def create
      save_and_render_json
    end
  
    private
  
    def creation_params
      prms = announcement_creation_params.slice(:content)
      prms[:club_id] = params[:club_id]
      prms[:members_ids] = announcements_members_ids
      prms
    end
  
    def announcement_creation_params
      @announcement_creation_params ||= 
        params.require(:announcement).permit(:content, groups_ids: [], members_ids: [])
    end
  
    def announcements_members_ids
      participants_ids = []
      groups = Group.where(club_id: params[:club_id], id: announcement_creation_params[:groups_ids])
      groups.each { |group| participants_ids = participants_ids + group.members_ids }
      members_ids = Member.where(club_id: params[:club_id], id: announcement_creation_params[:members_ids]).pluck(:id)
      (participants_ids + members_ids).uniq
    end
  end
end