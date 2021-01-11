# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment, Subscription], user_id: user.id
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author?(attachment.record)
    end
    can :destroy, Link do |link|
      user.author?(link.linkable)
    end
    can :select_best, Answer, user_id: user.id
    can [:up, :down, :check_answer_author, :check_question_author, :vote], [Question, Answer] do |resource|
      !user.author?(resource)
    end
  end
end
