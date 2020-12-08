class FindForOauthService
  attr_reader :auth

  def initialize(auth, email)
    @auth = auth
    @email = email
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = @email || auth.info[:email]
    #email = auth.info[:email] if auth.info && auth.info[:email]
    email_from_user = auth.info[:mail_from_user] if auth.info && auth.info[:mail_from_user]
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end

    user
  end
end
