require 'rails_helper'
RSpec.describe "Merchants API" do
  before(:all) do
    @merchant = create(:mock_merchant)
  end

  describe 'index' do
    before(:each) do
      create_list(:mock_merchant, 200)
    end

    it 'can send 20 merchants' do
      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(merchants[:data].size).to eq(20)
    end

    it 'can take limit param' do
      get '/api/v1/merchants', params: { per_page: 50}

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(body[:data].size).to eq(50)
    end

    it 'can take page param' do
      get '/api/v1/merchants', params: { page: 5 }

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(body[:data].size).to eq(20)
    end

    it 'can take both params' do
      get '/api/v1/merchants', params: { per_page: 37, page: 3 }

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(body[:data].size).to eq(37)
    end

    it 'can take a negative param' do
      get '/api/v1/merchants', params: { page: 0 }

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(body[:data].size).to eq(20)
    end
  end

  describe 'show' do
    it 'can find a single merchant' do
      create_list(:mock_merchant, 30)
      merchant = Merchant.first

      get "/api/v1/merchants/#{merchant.id}"

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(body[:data][:id]).to eq("#{merchant.id}")
    end
  end

  describe 'find' do
    it 'can find a merchant through a search' do
      create_list(:mock_merchant, 30)
      merchant = create(:mock_merchant, name: "Breakaway")

      get "/api/v1/merchants/find?name=akaw"

      body = JSON.parse(response.body, symbolize_names: true)
      
      expect(body[:data].first[:id]).to eq("#{merchant.id}")
      expect(body[:data].first[:type]).to eq("merchant")
      expect(body[:data].first[:attributes][:name]).to eq(merchant.name)
    end

    it 'can return empty array if no merchant is found' do
      get "/api/v1/merchants/find?name=akaw"

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:data]).to eq([])
    end
  end
end
