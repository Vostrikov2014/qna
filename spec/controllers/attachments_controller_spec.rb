require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:wrong_user) { create(:user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    let(:attachment) { question.files.first }

    subject { delete :destroy, params: { id: attachment, format: :js } }

    context 'вопрос принадлежит пользователю / user is question owner' do
      let!(:question) { create(:question, user: user) }

      it { expect { subject }.to change(ActiveStorage::Attachment, :count).by(-1) }
      it do
        subject
        expect(response).to render_template :destroy
      end
    end

    context 'вопрос не принадлежит пользователю / user is not question owner' do
      let!(:question) { create(:question, user: wrong_user) }

      it { expect { subject }.to_not change(ActiveStorage::Attachment, :count) }
    end
  end
end
