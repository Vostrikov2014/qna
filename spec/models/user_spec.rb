require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:authorizations).dependent(:destroy) }

  let(:user) { create(:user) }

  describe  '#author?' do
    it 'author of own question' do
      expect(user).to be_author(create(:question, user: user))
    end

    it 'not author of another question' do
      expect(user).to_not be_author(create(:question))
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let(:email) { nil }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      find_for_oauth(auth, email)
    end
  end
end
