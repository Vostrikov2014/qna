class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show

  def edit

  end

  def create
    answer.user = current_user
    if answer.save
      redirect_to answer.question
    else
      render 'questions/show'
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer
    else
      render :edit
    end
  end

  def destroy
    if current_user.author?(@answer)
      answer.destroy
      redirect_to answer.question
    else
      redirect_to answer.question, notice: 'Only the author can delete a answer'
    end
  end


  private

  def question
    @question = Question.find(params[:question_id])
  end
  helper_method :question

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : answers.build(answer_params)
  end
  helper_method :answer

  def answers
    @answers ||= question.reload.answers
  end
  helper_method :answers

  def answer_params
    params.require(:answer).permit(:body)
  end
end
