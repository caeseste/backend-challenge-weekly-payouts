FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password_digest { Faker::Internet.password }

    rfc { Faker::Code.npi }
    factory :merchant do
      user_type { "merchant" }

      factory :merchant_with_orders do
        transient do
          orders_count { 3 }
        end

        after(:create) do |merchant, evaluator|
          shopper = create(:shopper)
          create_list(:order, evaluator.orders_count, merchant: merchant, shopper: shopper)
        end
      end
    end
    factory :shopper do
      user_type { "shopper" }
    end
  end
end
