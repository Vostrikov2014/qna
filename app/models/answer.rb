class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  validates :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank

  scope :sort_by_best, -> { order(best: :desc) }

  def select_best!
    transaction do
      question.answers.update_all(best:false)
      update!(best: true)
      question.reward&.update!(user_id: user_id)
    end
  end
end
