class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :auth_in_session, only: %i[github vkontakte]

  def github
    #render json: request.env['omniauth.auth']
    if session['omniauth.auth']['info']['email']
      auth_authentication
    else
      if Authorization.where(provider: session['omniauth.auth']['provider'], uid: session['omniauth.auth']['uid'].to_s).first
        auth_authentication
      else
        render 'confirmations/email', locals: { provider: session['omniauth.auth']['provider'], user: @user }
      end
    end
  end

  #def facebook
  #end

  def vkontakte
    if session['omniauth.auth']['info']['email'].nil?
      auth_authentication
    else
      if Authorization.where(provider: session['omniauth.auth']['provider'], uid: session['omniauth.auth']['uid'].to_s).first
        auth_authentication
      else
        render 'confirmations/email', locals: { provider: session['omniauth.auth']['provider'], user: @user }
      end
    end
  end

  def custom_email
    session['omniauth.auth']['info']['mail_from_user'] = params[:email]
    auth_authentication
  end


  private

  def auth_authentication
    @user = FindForOauthService.new(session['omniauth.auth']).call
    if @user&.persisted? && @user&.confirmed_at?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: session['omniauth.auth'].provider.capitalize) if is_navigational_format?

    elsif @user&.persisted? && !@user&.confirmed_at?
      flash[:alert] = t('devise.failure.unconfirmed')
      redirect_to new_user_session_path
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def auth_in_session
    session['omniauth.auth'] = request.env['omniauth.auth'].except("extra")
  end
end
