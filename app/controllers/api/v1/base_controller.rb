class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json do
        render json: { error: exception.message }, status: 403
      end
    end
  end

  private

  def current_resource_owner
    # Нужно найти юзера (User.find), в контроллерах которые защещины доркипером можно получить токен
    # который был передан (doorkeeper_token.resource_owner_id)
    # когда вызываем doorkeeper_token - доркипер по токену находит запись в таблице access_token,
    # возвращает запись в виде объекта и у него запрашиваем resource_owner_id.
    # !!! будет работать если токен передан, поэтому if...
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end
