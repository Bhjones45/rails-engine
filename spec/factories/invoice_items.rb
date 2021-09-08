FactoryBot.define do
  factory :mock_invoice_item, class: InvoiceItem do
    quantity { Faker::Number.within(range: 1..20) }
    unit_price { Faker::Number.within(range: 1..200) }

    association :item, factory: :mock_item
    association :invoice, factory: :mock_invoice
  end
end
