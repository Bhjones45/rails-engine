require 'rails_helper'
RSpec.describe Invoice do
  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'class methods' do
    describe 'potential_revenue' do
      it 'can calculate revenue for each invoice with packaged status' do
        merchant1 = create(:mock_merchant)

        customer1 = create(:mock_customer)
        customer2 = create(:mock_customer)
        customer3 = create(:mock_customer)

        item1 = create(:mock_item, merchant: merchant1)
        item2 = create(:mock_item, merchant: merchant1)
        item3 = create(:mock_item, merchant: merchant1)

        invoice1 = create(:mock_invoice, merchant: merchant1, customer: customer1, status: 'packaged')
        invoice2 = create(:mock_invoice, merchant: merchant1, customer: customer1, status: 'packaged')
        invoice3 = create(:mock_invoice, merchant: merchant1, customer: customer2, status: 'shipped')
        invoice4 = create(:mock_invoice, merchant: merchant1, customer: customer2, status: 'packaged')
        invoice5 = create(:mock_invoice, merchant: merchant1, customer: customer3, status: 'shipped')
        invoice6 = create(:mock_invoice, merchant: merchant1, customer: customer3, status: 'packaged')
        invoice7 = create(:mock_invoice, merchant: merchant1, customer: customer3, status: 'packaged')
        invoice8 = create(:mock_invoice, merchant: merchant1, customer: customer3, status: 'packaged')
        invoice9 = create(:mock_invoice, merchant: merchant1, customer: customer3, status: 'packaged')

        invoice_item1 = create(:mock_invoice_item, item: item1, invoice: invoice1, quantity: 5, unit_price: 20)
        invoice_item2 = create(:mock_invoice_item, item: item2, invoice: invoice2, quantity: 15, unit_price: 3)
        invoice_item3 = create(:mock_invoice_item, item: item3, invoice: invoice3, quantity: 10, unit_price: 4)
        invoice_item4 = create(:mock_invoice_item, item: item1, invoice: invoice4, quantity: 12, unit_price: 2)
        invoice_item5 = create(:mock_invoice_item, item: item2, invoice: invoice5, quantity: 5, unit_price: 10)
        invoice_item6 = create(:mock_invoice_item, item: item3, invoice: invoice6, quantity: 5, unit_price: 10)
        invoice_item7 = create(:mock_invoice_item, item: item3, invoice: invoice7, quantity: 5, unit_price: 10)
        invoice_item8 = create(:mock_invoice_item, item: item3, invoice: invoice8, quantity: 5, unit_price: 10)
        invoice_item9 = create(:mock_invoice_item, item: item3, invoice: invoice9, quantity: 5, unit_price: 10)

        transactions1 = create(:mock_transaction, invoice: invoice1, result: 'success')
        transactions2 = create(:mock_transaction, invoice: invoice2, result: 'success')
        transactions3 = create(:mock_transaction, invoice: invoice3, result: 'success')

        potential_rev = Invoice.potential_revenue.first

        expect(potential_rev.id).to eq(invoice1.id)
        expect(potential_rev.potential_revenue).to eq(100.0)
      end
    end
  end
end
