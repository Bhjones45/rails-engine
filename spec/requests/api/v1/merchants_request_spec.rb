require 'rails_helper'
RSpec.describe "Merchants API" do
  before(:all) do
    @merchant = create(:mock_merchant)
  end

    context 'index' do
      before(:each) do
        create_list(:mock_merchant, 200)
      end

      it 'can send 20 merchants' do
        get '/api/v1/merchants'

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].size).to eq(20)
      end
    end
end
