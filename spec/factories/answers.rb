FactoryBot.define do
  factory :answer do
    body { "My answer" }
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
