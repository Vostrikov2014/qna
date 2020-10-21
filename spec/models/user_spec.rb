require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe  '#author?' do
    let(:user) { create(:user) }

    it 'автор собственного вопроса / author of own question' do
      expect(user).to be_author(create(:question, user: user))
    end

    it 'не автор другого вопроса / not author of another question' do
      expect(user).to_not be_author(create(:question))
    end
  end
end
