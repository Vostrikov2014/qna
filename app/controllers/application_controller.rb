class ApplicationController < ActionController::Base
  before_action :set_gon_user_id

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  check_authorization unless: :devise_controller?

  private

  def set_gon_user_id
    gon.user_id = current_user&.id
  end
end
