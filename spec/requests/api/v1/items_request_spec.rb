require 'rails_helper'
RSpec.describe "Items API" do
  before(:all) do
    @merchant = create(:mock_merchant)
  end

  describe 'index' do
    before(:each) do
      create_list(:mock_item, 200, merchant: @merchant)
    end

    it 'returns 20 items' do
      get '/api/v1/items'

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(body[:data].size).to eq(20)
    end

    it 'can take limit param' do
      get '/api/v1/items', params: { per_page: 50}

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(body[:data].size).to eq(50)
    end

    it 'can take page param' do
      get '/api/v1/items', params: { page: 5 }

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(body[:data].size).to eq(20)
    end

    it 'can take both params' do
      get '/api/v1/items', params: { per_page: 37, page: 3 }

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(body[:data].size).to eq(37)
    end

    it 'can take a negative param' do
      get '/api/v1/items', params: { page: 0 }

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(body[:data].size).to eq(20)
    end
  end

  describe 'show' do
    it 'can show a single item' do
      create_list(:mock_item, 10, merchant: @merchant)
      first_item = Item.first
      get "/api/v1/items/#{first_item.id}"

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(body[:data][:attributes][:name]).to eq(first_item.name)
      expect(body[:data][:attributes][:description]).to eq(first_item.description)
      expect(body[:data][:attributes][:unit_price]).to eq(first_item.unit_price)
      expect(body[:data][:attributes][:merchant_id]).to eq(first_item.merchant_id)
    end
  end

  describe 'create' do
    it 'can create a new item' do
      post "/api/v1/items", params: {
        name: 'Breakaway',
        description: 'You will never catch me!',
        unit_price: 18,
        merchant_id: @merchant.id
      }

      created_item = JSON.parse(response.body, symbolize_names: true)
      find_item = Item.find(created_item[:data][:id])

      expect(response).to be_successful
      expect(created_item[:data][:attributes][:name]).to eq(find_item.name)
      expect(created_item[:data][:attributes][:description]).to eq(find_item.description)
      expect(created_item[:data][:attributes][:unit_price]).to eq(find_item.unit_price)
      expect(created_item[:data][:attributes][:merchant_id]).to eq(find_item.merchant_id)
    end
  end

  describe 'update' do
    it 'can update an item' do
      item = create(:mock_item, merchant: @merchant)
      original_item = Item.first.name
      patch "/api/v1/items/#{item.id}", params: {
                                          name: "Breakaway"
                                        }

      body = JSON.parse(response.body, symbolize_names: true)

      updated_item = Item.find_by(id: item)

      expect(response).to be_successful
      expect(updated_item.name).to_not eq(original_item)
      expect(updated_item.name).to eq("Breakaway")
    end
  end

  describe 'delete' do
    it 'can destroy an item' do
      item = create(:mock_item, merchant: @merchant)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
