FactoryBot.define do
  sequence :title do |n|
    "title#{n}"
  end

  factory :question do
    title
    user
    body { "MyText" }
  end

  trait :invalid do
    title { nil }
  end

  trait :with_links do
    before :create do |question|
      create_list(:link, 3, linkable: question)
    end
  end

  trait :with_files do
    after :create do |question|
      file_path1 = Rails.root.join('app', 'assets', 'images', 'qna1.jpg')
      file_path2 = Rails.root.join('app', 'assets', 'images', 'qna2.jpg')
      file1 = fixture_file_upload(file_path1, 'image/jpeg')
      file2 = fixture_file_upload(file_path2, 'image/jpeg')
      question.files.attach(file1, file2)
    end
  end
end
