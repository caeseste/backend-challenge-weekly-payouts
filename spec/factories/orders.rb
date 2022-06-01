FactoryBot.define do
  # with user as argument
  factory :order do
    merchant
    shopper

    # transient do
    # end
    amount { 100 }

    created_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    updated_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }

    trait :completed do
      completed_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    end

    trait :incomplete do
      completed_at { nil }
    end
  end
end
