class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_for "comments_#{params[:question_id]}"
  end

  def follow(data)
    unfollow
    stream_from "question_#{data['id']}_comments"
  end

  def unfollow
    stop_all_streams
  end
end
