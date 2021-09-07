require 'rails_helper'
RSpec.describe "Item merchant" do
  describe 'index' do
    it "can find item's merchant" do
      merchant = create(:mock_merchant)
      item = create(:mock_item, merchant: merchant)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:data][:id]).to eq(merchant.id.to_s)
    end
  end
end
