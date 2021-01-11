class Question < ApplicationRecord
  include Authorable
  include Votable
  include Commentable

  belongs_to :user

  has_many :answers, -> { order('best DESC, created_at') }, dependent: :destroy
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation
  after_save :create_subscription

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  def subscription(user)
    subscriptions.find_by(user: user)
  end


  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def create_subscription
    subscriptions.create(user_id: user_id, question_id: self)
  end
end
