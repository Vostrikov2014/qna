module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[up down cancel_vote]

    def up
      @votable.create_positive_vote(current_user) unless current_user.author?(@votable)
      success_response
    end

    def down
      @votable.create_negative_vote(current_user) unless current_user.author?(@votable)
      success_response
    end

    def cancel_vote
      @votable.votes.find_by(user_id: current_user.id).try(:destroy)
      success_response
    end

    private

    def model_klass
      controller_name.classify.constantize
    end

    def set_votable
      @votable = model_klass.find(params[:id])
    end

    def success_response
      render json: {id: @votable.id, rating: @votable.rating, type: @votable.class.name.downcase}
    end
  end
end
