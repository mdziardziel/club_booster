class ApiAuthorizedController < ApplicationController
  include AuthorizeActionsHelper

  before_action :authenticate_user!
end
