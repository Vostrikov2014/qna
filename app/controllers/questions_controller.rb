class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :check_question_author, only: :update
  after_action :publish_question, only: :create

  include Voted

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @comment = @question.comments.build
  end

  def new
    @question = Question.new
    @question.build_reward
  end

  def edit
  end

  def create
    @question = Question.new(question_params.merge(user: current_user))

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question was successfully deleted.'
  end


  private

  def load_question
    gon.question_id = params[:id]
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url], reward_attributes: %i[title file])
  end

  def check_question_author
    authorize! :check_question_author, @question
    head(:forbidden)
  end

  def publish_question
    return if @question.errors.any?
    #ActionCable.server.broadcast('questions', question: @question)
    QuestionsChannel.broadcast_to('questions', question: @question)  #правильный вариант
  end
end
