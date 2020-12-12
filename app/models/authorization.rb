class Authorization < ApplicationRecord
  belongs_to :user, dependent: :destroy

  validates :provider, :uid, presence: true
end
