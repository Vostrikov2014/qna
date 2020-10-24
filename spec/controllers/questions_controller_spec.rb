require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'заполняет массив всех вопросов / populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end


  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'назначает запрошенный вопрос для @question / assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'назначает новый вопрос для @question / assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'отображает просмотр new / renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'назначает запрошенный вопрос для @question / assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'отображает просмотр edit / renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'с действительными атрибутами / with valid attributes' do
      it 'сохраняет вопрос в базе данных / saves a question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'аутентифицированный пользователь будет автором вопроса / authenticated user to be author of question' do
        post :create, params: {question: attributes_for(:question)}
        expect(user).to be_author(assigns(:question))
      end

      it 'отображает просмотр show / redirects to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'с недопустимыми атрибутами / with invalid attributes' do
      it 'не сохраняет вопрос / does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'повторно отображает новый вид / re-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'с действительными атрибутами / with valid attributes' do
      it 'устанавливает переменную question в объект @question по id / assigns requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'изменяет существующие атрибуты / changes question attributes' do
        patch :update, params: { id: question, question: {title: 'new title', body: 'new body'}, format: :js}
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: {id: question, question: attributes_for(:question), format: :js}
        expect(response).to redirect_to question
      end
    end

    context 'с недопустимыми атрибутами / with invalid attributes' do
      before { patch :update, params: {id: question, question: attributes_for(:question, :invalid), format: :js } }

      it 'не меняет вопрос / does not change question' do
        question.reload

        expect(question.title).to_not eq nil
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end


  describe 'DELETE #destroy' do
    before { login(user) }

    # Important! We do it before every Rspec-test!
    let!(:question) { user.questions.create(attributes_for(:question)) }
    let!(:other_question) { create(:question) }

    context 'автор / author' do
      it 'удалить вопрос / deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'перенаправляет на индекс / redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'не автор / not author' do
      it 'нет удаляет вопрос / no deletes the question' do
        expect { delete :destroy, params: { id: other_question } }.to_not change(Question, :count)
      end

      it 'перенаправляет на index / redirects to index' do
        delete :destroy, params: { id: other_question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end

