require 'rails_helper'
RSpec.describe 'Revenue' do
  before(:each) do
    @merchant1 = create(:mock_merchant)
    @merchant2 = create(:mock_merchant)

    @customer1 = create(:mock_customer)
    @customer2 = create(:mock_customer)
    @customer3 = create(:mock_customer)

    @item1 = create(:mock_item, merchant: @merchant1)
    @item2 = create(:mock_item, merchant: @merchant1)
    @item3 = create(:mock_item, merchant: @merchant1)

    @invoice1 = create(:mock_invoice, merchant: @merchant1, customer: @customer1, status: 'shipped')
    @invoice2 = create(:mock_invoice, merchant: @merchant1, customer: @customer2, status: 'shipped')
    @invoice3 = create(:mock_invoice, merchant: @merchant1, customer: @customer2, status: 'packaged')
    @invoice4 = create(:mock_invoice, merchant: @merchant1, customer: @customer3, status: 'shipped')
    @invoice5 = create(:mock_invoice, merchant: @merchant1, customer: @customer3, status: 'packaged')
    @invoice6 = create(:mock_invoice, merchant: @merchant1, customer: @customer3, status: 'packaged')

    @invoice_item1 = create(:mock_invoice_item, item: @item1, invoice: @invoice1, quantity: 5, unit_price: 2)
    @invoice_item2 = create(:mock_invoice_item, item: @item2, invoice: @invoice2, quantity: 15, unit_price: 6)
    @invoice_item3 = create(:mock_invoice_item, item: @item3, invoice: @invoice3, quantity: 10, unit_price: 4)
    @invoice_item4 = create(:mock_invoice_item, item: @item1, invoice: @invoice4, quantity: 5, unit_price: 2)
    @invoice_item5 = create(:mock_invoice_item, item: @item2, invoice: @invoice5, quantity: 6, unit_price: 6)
    @invoice_item6 = create(:mock_invoice_item, item: @item3, invoice: @invoice6, quantity: 7, unit_price: 4)

    @transactions1 = create(:mock_transaction, invoice: @invoice1, result: 'success')
    @transactions2 = create(:mock_transaction, invoice: @invoice2, result: 'success')
    @transactions3 = create(:mock_transaction, invoice: @invoice3, result: 'success')
  end

  describe 'total revenue' do
    it 'can return total revenue of a merchant' do

      get "/api/v1/revenue/merchants", params: { quantity: 1 }

      merchants = body = JSON.parse(response.body, symbolize_names: true)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:attributes)
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq('merchant_name_revenue')
      end
    end
  end

  describe 'unshipped orders potential revenue' do
    it 'can return potential revenue of unshipped orders' do
      get '/api/v1/revenue/unshipped'

      body =JSON.parse(response.body, symbolize_names: true)

      expect(body[:data].size).to eq(3)
      expect(body[:data].first[:type]).to eq("unshipped_order")
      expect(body[:data].first[:attributes][:potential_revenue]).to eq(40.0)
    end

    it 'sad path: returns error if quantity value is left blank' do
      get '/api/v1/revenue/unshipped', params: { quantity: ''}

      body =JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it 'sad path: returns error if quantity value is a string' do
      get '/api/v1/revenue/unshipped', params: { quantity: 'heyo'}

      body =JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
end
