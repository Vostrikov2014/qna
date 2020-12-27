class ApplicationController < ActionController::Base
  before_action :set_gon_user_id

  check_authorization unless: :devise_controller?
  #skip_authorization_check

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html do
        redirect_to root_url, alert: exception.message
      end
      format.json do
        render json: { error: exception.message }, status: 403
      end
      format.js do
        render json: { error: exception.message }, status: 403
      end
    end
  end

  private

  def set_gon_user_id
    gon.user_id = current_user&.id
  end
end
