class ClubsController < ApiAuthorizedController

  def create
    save_and_render_json
  end

  private


  def creation_params
    params.require(:club).permit(:name).merge(owner_id: current_user.id)
  end
end