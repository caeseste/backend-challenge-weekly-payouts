FactoryBot.define do
  # with user as argument
  factory :order do
    merchant
    shopper

    amount { 100 }

    created_at { Faker::Time.between(from: DateTime.now - 14, to: DateTime.now - 7) }

    trait :completed do
      completed_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    end

    trait :incomplete do
      completed_at { nil }
    end
  end
end
