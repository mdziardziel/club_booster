module Api
  class SessionsController < Devise::SessionsController
    skip_before_action :verify_signed_out_user, only: :destroy

    def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)

      render json: {message: 'signed in successfully!'}, status: 200
    end
  
    def destroy
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message! :notice, :signed_out if signed_out
  
      render json: {message: 'signed out successfully!'}, status: 200
    end
  end 
end