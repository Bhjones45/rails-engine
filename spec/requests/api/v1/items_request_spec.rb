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
end
