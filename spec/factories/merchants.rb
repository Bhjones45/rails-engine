FactoryBot.define do
  factory :mock_merchant, class: Merchant do
    name { Faker::Fantasy::Tolkien.character }
  end
end
