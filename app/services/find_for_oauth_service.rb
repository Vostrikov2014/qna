class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth['provider'], uid: auth['uid'].to_s).first
    return authorization.user if authorization

    email = nil #auth.info[:email]
    email_from_user = auth['info']['mail_from_user']
    password = Devise.friendly_token[0, 20]

    user = User.where(email: email).first
    if user
      create_authorization(user, auth)
    elsif email
      user = User.create!(email: email, password: password, password_confirmation: password)
      create_authorization(user, auth)
    else
      user = User.create!(email: email_from_user, password: password, password_confirmation: password)
      create_authorization(user, auth)
    end

    user
  end

  private

  def create_authorization(user, auth)
    user.authorizations.create(provider: auth['provider'], uid: auth['uid'])
  end
end
