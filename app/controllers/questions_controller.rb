class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show

  end

  def new
    question
  end

  def edit

  end

  def create
    @question = Question.new(question_params.merge(user: current_user))

    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author?(question)
      question.destroy
      redirect_to questions_path
    else
      redirect_to questions_path, notice: 'Only the author can delete a question'
    end
  end


  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end
  helper_method :question

  def answer
    @answer ||= question.answers.new
  end
  helper_method :answer

  def answers
    @answers ||= question.reload.answers
  end
  helper_method :answers

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
