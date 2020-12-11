class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :auth_in_session, only: %i[github vkontakte]

  def github
    #render json: request.env['omniauth.auth']
    auth_authentication
  end

  #def facebook
  #end

  def vkontakte
    auth_authentication
  end

  private

  def auth_authentication
    @user = FindForOauthService.new(session['omniauth.auth']).call
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: session['omniauth.auth'].provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def auth_in_session
    session['omniauth.auth'] = request.env['omniauth.auth'].except("extra")
  end
end
