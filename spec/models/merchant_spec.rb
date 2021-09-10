require 'rails_helper'
RSpec.describe Merchant do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { should have_many(:invoices) }
    it { should have_many(:items) }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
  end

  describe 'class methods' do
    describe "::top_revenue" do
      it 'can return merchant with the top revenue' do
        merchant1 = create(:mock_merchant)
        merchant2 = create(:mock_merchant)
        merchant3 = create(:mock_merchant)

        customer1 = create(:mock_customer)
        customer2 = create(:mock_customer)
        customer3 = create(:mock_customer)

        item1 = create(:mock_item, merchant: merchant1)
        item2 = create(:mock_item, merchant: merchant2)
        item3 = create(:mock_item, merchant: merchant3)

        invoice1 = create(:mock_invoice, merchant: merchant1, customer: customer1, status: 'shipped')
        invoice2 = create(:mock_invoice, merchant: merchant2, customer: customer2, status: 'shipped')
        invoice3 = create(:mock_invoice, merchant: merchant3, customer: customer3, status: 'shipped')

        invoice_item1 = create(:mock_invoice_item, item: item1, invoice: invoice1, quantity: 5, unit_price: 2)
        invoice_item2 = create(:mock_invoice_item, item: item2, invoice: invoice2, quantity: 15, unit_price: 6)
        invoice_item3 = create(:mock_invoice_item, item: item3, invoice: invoice3, quantity: 10, unit_price: 4)

        transactions1 = create(:mock_transaction, invoice: invoice1, result: 'success')
        transactions2 = create(:mock_transaction, invoice: invoice2, result: 'success')
        transactions3 = create(:mock_transaction, invoice: invoice3, result: 'success')

        top = Merchant.top_revenue.first
        bottom = Merchant.top_revenue.last

        top_rev = Merchant.merchant_revenue(merchant2.id).first
        bottom_rev = Merchant.merchant_revenue(merchant1.id).first

        expect(top.id).to eq(merchant2.id)
        expect(top.revenue).to eq(top_rev.revenue)
        expect(bottom.id).to eq(merchant1.id)
        expect(bottom.revenue).to eq(bottom_rev.revenue)
      end
    end
  end
end
