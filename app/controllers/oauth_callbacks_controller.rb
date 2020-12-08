class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    #render json: request.env['omniauth.auth']
    auth_authentication('Github', request.env['omniauth.auth'].try(:[], 'info').try(:[], 'email'))
  end

  #def facebook
  #end

  def vkontakte
    if User.where(vkontakte_name: request_info.try(:[], 'name')).length == 0
      if request_info.try(:[], 'email').blank? && !session[:pre_email]
        redirect_to new_advanced_registration_path and return
      end
    end

    email = session[:pre_email] || User.where(vkontakte_name: request_info.try(:[], 'name')).first&.email
    auth_authentication('Vkontakte', email)
  end

  private

  def auth_authentication(provider_name, email)
    #@user = User.find_for_oauth(request.env['omniauth.auth'])
    auth = request.env['omniauth.auth']
    @user = FindForOauthService.new(auth, email).call

    if @user&.persisted?
      @user.add_vkontakte_name(request_info.try(:[], 'email'))
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def request_info
    request.env['omniauth.auth'].try(:[], 'info')
  end
end
