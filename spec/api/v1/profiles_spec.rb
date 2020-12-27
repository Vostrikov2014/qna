require 'rails_helper'

describe 'Profile API', type: :request do
  # CONTENT_TYPE - передаем данные в json
  # ACCEPT - принимаем данные в json
  let(:headers) {{ "CONTENT_TYPE" => "application/json", "ACCEPT" => 'application/json' }}

  describe 'GET /api/v1/profiles/me' do
    let(:me) { create(:user) }
    # акцесс токен должен быть связан с созданным пользователем "resource_owner_id: me.id"
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:method) { :get }  # Используется только в 'API Authorizable' но можно оставить и для "общего" доступа
    let(:api_path) { '/api/v1/profiles/me' }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API Authorizable'  # вызов общих проверок

    it 'returns 200 status' do
      # тут нужно указать валидный token - access_token.token - это валидный токен. Перенесем в before (выше)
      # get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
      # чтобы получить access_token.token создадим фабрику oauth_application.rb
      expect(response).to be_successful  #be_successful - ответ успешный (200, 201 и т.д.). Проверяем не статус а сам объект response
    end

    # проверим поля возвращаемые json-ом
    # для этого создадим юзера "let(:me) { create(:user) }" см. выше
    # !!! проверим публичные поля
    it 'returns all public fields' do
      #json = JSON.parse(response.body) - !!! перенесли в хелпер spec/support/api_helper.rb
      %w[id email admin created_at updated_at].each do |attr|
        expect(json[attr]).to eq me.send(attr).as_json
        #.as_json - преобразование в формат json, иначе created_at updated_at
        # рабтать не будут из за форматы дат...
      end
    end

    # В случае с пользоватлем, нужно проверить что НЕ включаются поля password encrypted_password
    it 'does not return private fields' do
      %w[password encrypted_password].each do |attr|
        expect(json).to_not have_key(attr)  # проверить что в json нет такого ключа
      end
    end
  end

  describe 'GET /api/v1/profiles/' do
    let(:me) { create(:user) }
    let!(:users) { create_list(:user, 4) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:user_response) { json['users'].first }
    let(:user) { users.first }
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles/' }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API Authorizable'

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns all public fields' do
      %w[id email created_at updated_at].each do |attr|
        expect(user_response[attr]).to eq user.send(attr).as_json
      end
    end

    it 'does not return private fields' do
      %w[password encrypted_password].each do |attr|
        expect(user_response).to_not have_key(attr)
      end
    end

    it 'users list not contains current user' do
      json.each do |user|
        expect(user).to_not include('id' => me.id)
      end
    end
  end
end
