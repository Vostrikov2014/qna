require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user)  }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:other_answer) { create(:answer) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'authenticated user to be author of answer' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer), format: :js }
        expect(user).to be_author(assigns(:answer))
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: {body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        answer.reload
        expect(answer.body).to eq 'My answer'
      end

      it 'returns forbidden' do
        patch :update, params: {id: other_answer, format: :js}
        expect(response).to be_forbidden
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'author' do
      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to redirect_to answer_path
      end
    end

    context 'not author' do
      it 'no delete the answer' do
        expect { delete :destroy, params: { id: other_answer, format: :js } }.to_not change(Answer, :count)
      end

      it 'returns forbidden' do
        delete :destroy, params: {id: other_answer, format: :js}
        expect(response).to be_forbidden
      end
    end
  end

  describe 'POST #select_best' do
    before { login(user) }

    context 'author' do
      before { post :select_best, params: {id: answer, format: :js} }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'update best attribute' do
        answer.reload
        expect(answer.best).to eq true
      end

      it 'render select_best template' do
        expect(response).to render_template :select_best
      end
    end

    context 'not author' do
      before { post :select_best, params: {id: other_answer, format: :js} }

      it 'not update best attribute' do
        answer.reload
        expect(answer.best).to_not eq true
      end

      it 'returns forbidden' do
        expect(response).to be_forbidden
      end
    end
  end

  describe 'Active job notice' do
    before do
      login(user)
      clear_enqueued_jobs
    end

    subject { post :create, params: { question_id: question, answer: answer_params, format: :js } }

    let(:answer_params) { attributes_for(:answer) }

    it 'answer owner subscribed to question' do
      expect { subject }.to change(enqueued_jobs, :count).by(1)
    end

    it 'question subscribers not exists' do
      question.subscriptions.delete_all
      expect { subject }.to change(enqueued_jobs, :count).by(0)
    end

    it 'create correct job' do
      expect { subject }.to have_enqueued_job(NewAnswerNoticeJob)
    end
  end
end
