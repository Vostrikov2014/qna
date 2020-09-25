require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:user) { create(:user) }

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: {id: answer} }

    it 'assigns requested answer to answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'authenticated user to be author of answer' do
        post :create, params: {question_id: answer.question, answer: attributes_for(:answer)}
        expect(user).to be_author(assigns(:answer))
      end

      it 'redirects to show' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template "questions/show"
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns requested answer to @answer' do
        patch :update, params: {id: answer, answer: attributes_for(:answer)}
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: {id: answer, answer: {body: 'new body'}}
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to updated answer' do
        patch :update, params: {id: answer, answer: attributes_for(:answer)}
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)} }

      it 'does not change answer' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    context 'author' do
      before { login(answer.user) }

      it 'delete the answer' do
        expect { delete :destroy, params: {id: answer} }.to change(Answer, :count).by(-1)
      end
      it 'redirects to index' do
        delete :destroy, params: {id: answer}
        expect(response).to redirect_to answer.question
      end
    end

    context 'not author' do
      before { login(user) }

      it 'no delete the answer' do
        expect { delete :destroy, params: {id: answer} }.to_not change(Answer, :count)
      end
      it 'redirects to index' do
        delete :destroy, params: {id: answer}
        expect(response).to redirect_to answer.question
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
end
