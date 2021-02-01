class AnswersChannel < ApplicationCable::Channel
  def subscribed
    puts params.inspect
    stream_for "questions_#{params[:question_id]}"  #так исправил - этот вариант от ивана
    #stream_for "answers_#{params[:question_id]}" #так было
  end

  def follow(data)
    unfollow
    stream_from "answers_for_question_#{data['id']}"
  end

  def unfollow
    stop_all_streams
  end
end
