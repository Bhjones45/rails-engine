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
end
