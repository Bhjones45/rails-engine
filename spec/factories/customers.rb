FactoryBot.define do
  factory :mock_customer, class: Customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
