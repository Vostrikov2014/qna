class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :body, :created_at, :updated_at, :files

  has_many :links
  has_many :comments

  def files
    object.files.map do |file|
      { id: file.id, url: rails_blob_url(file, only_path: true) }
    end
  end
end
