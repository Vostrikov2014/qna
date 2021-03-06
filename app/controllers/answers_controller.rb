class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[index create]
  before_action :load_answer, only: %i[show edit update destroy select_best]
  before_action :check_answer_author, only: %i[update destroy]
  before_action :check_question_author, only: :select_best
  after_action :publish_answer, only: :create

  include Voted

  authorize_resource

  def index
    @answers = @question.answers
  end

  def show
    @comment = @answer.comments.build
  end

  def new
    @answer = @question.answers.new
  end

  def edit
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def select_best
    @answer.select_best!
  end

  private

  def find_question
    gon.question_id = params[:question_id]
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def check_question_author
    authorize! :check_question_author, @answer.question
    head(:forbidden)
  end

  def check_answer_author
    authorize! :check_answer_author, @answer
    head(:forbidden)
  end

  def publish_answer
    return if @answer.errors.any?
    gon.question_id = params[:question_id]
    #ActionCable.server.broadcast("questions_#{@answer.question_id}", @answer.attributes.merge(rating: @answer.rating))
    AnswersChannel.broadcast_to("questions_#{@answer.question_id}", @answer.attributes.merge(rating: @answer.rating))
  end
end
