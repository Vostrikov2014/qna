class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_for 'questions'
  end

  def follow
    unfollow
    stream_from 'questions'
  end

  def unfollow
    stop_all_streams
  end
end
