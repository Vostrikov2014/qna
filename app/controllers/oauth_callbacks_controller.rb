class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :auth_in_session, only: %i[github vkontakte]

  def github
    #render json: request.env['omniauth.auth']
    #auth_authentication(request.env['omniauth.auth'], request.env['omniauth.auth'].try(:[], 'info').try(:[], 'email'))
    auth_authentication
  end

  #def facebook
  #end

  def vkontakte
    #if User.where(vkontakte_name: request_info.try(:[], 'name')).length == 0
    #  if request_info.try(:[], 'email').blank? && !session[:pre_email]
    #    redirect_to new_advanced_registration_path and return
    #  end
    #end

    #email = session[:pre_email] || User.where(vkontakte_name: request_info.try(:[], 'name')).first&.email
    auth_authentication
  end

  private

  def auth_authentication
    @user = FindForOauthService.new(session['omniauth.auth']).call
    if @user&.persisted?
      @user.add_vkontakte_name(request_info.try(:[], 'email'))
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: session['omniauth.auth'].provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def request_info
    request.env['omniauth.auth'].try(:[], 'info')
  end

  def auth_in_session
    session['omniauth.auth'] = request.env['omniauth.auth'].except("extra")
  end
end
