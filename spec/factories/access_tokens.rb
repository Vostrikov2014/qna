# Фабрика для акцесс токена
FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    # Ассоциация с приложением
    association :application, factory: :oauth_application

    # id некоторого пользователя. Doorkeeper не знает как будут называться модели пользователей,
    # поэтому ассоциацию он построить не может. Поэтому Doorkeeper хранит id и мы должны id указывать
    # create(:user).id - создаем пользователся и берем id
    resource_owner_id { create(:user).id }
  end
end
