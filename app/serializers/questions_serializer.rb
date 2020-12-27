class QuestionsSerializer < ActiveModel::Serializer
  # указываем какие атрибуты в json должны возвращаться
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  has_many :answers # включают ассоциацию определенную в наш объект
  belongs_to :user

  def short_title
    object.title.truncate(7)
  end
end
