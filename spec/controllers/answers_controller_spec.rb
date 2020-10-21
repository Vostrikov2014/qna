require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user)  }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:other_answer) { create(:answer) }

  describe 'POST #create' do
    before { login(user) }

    context 'валидное создание / with valid attributes' do
      it 'сохранение ответа в базе данных / save a answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'ответил аутентифицированный пользователь / authenticated user to be author of answer' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer), format: :js }
        expect(user).to be_author(assigns(:answer))
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'не валидное создание / with invalid attributes' do
      it 'не записан в базу данных / does not save the answer' do
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

    context 'валидное обновление / with valid attributes' do
      it 'устанавливает переменную answer в объект @answer по id / assigns requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'изменяет существующие атрибуты / changes answer attributes' do
        patch :update, params: { id: answer, answer: {body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(response).to redirect_to answer
      end
    end

    context 'не валидное обновление / with invalid attributes' do
      it 'не изменяется ответ / does not change answer' do
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

    context 'автор / author' do
      it 'удалить ответ / delete the answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to redirect_to answer_path
      end
    end

    context 'не автор / not author' do
      it 'ответ не удаляется / no delete the answer' do
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
end
