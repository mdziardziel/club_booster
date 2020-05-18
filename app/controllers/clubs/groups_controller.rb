module Clubs
  class GroupsController < ApiAuthorizedController
    include ClubMember
    include CreationHelper
  
    before_action :authorize_only_club_members
    before_action :authorize_only_president_or_coach_role, only: %i(destroy index show create update)
  
    def index
      render json: club.groups
    end

    def show
      render json: Group.find_by(club_id: club.id, id: params[:id])
    end

    def create
      save_and_render_json
    end
  
    def update
      update_and_render_json
    end

    def destroy
      group = Group.find_by(club_id: club.id, id: params[:id]).destroy
      render json: group
    end
  
    private
  
    def creation_params
      prms = params.require(:group).permit(:name, members_ids: [])
      prms[:club_id] = params[:club_id]
      prms[:members_ids] = Member.where(id: prms[:members_ids], club_id: params[:club_id]).pluck(:id)
      prms
    end
  end
end