class ApiController < ApplicationController
  protect_from_forgery with: :null_session

  respond_to :json

  private

  def resource_owner
    User.find(doorkeeper_token.resource_owner_id)
  end

  def current_resource_owner
    current_user || resource_owner
  end
end
