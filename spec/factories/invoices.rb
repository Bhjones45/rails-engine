FactoryBot.define do
  factory :mock_invoice, class: Invoice do
    status { [0, 1, 2].sample }

    association :customer, factory: :mock_customer
  end
end
