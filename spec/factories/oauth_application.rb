# Фабрика для приложения
FactoryBot.define do
  # У нас нет класса (фабрика привязывается к модели) а нам нужно создавать фабрику для Doorkeeper::Application -
  # это именно та модель которая будет использоваться, нам ее поставил Doorkeeper, когда поставили его в проект.
  # пишем , class: 'Doorkeeper::Application' do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'Test' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }  # То что задовали в Application oauth
    uid { '12345678' }
    secret { '876543212' }
  end
end
