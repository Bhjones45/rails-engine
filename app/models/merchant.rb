class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.merchant_revenue(merchant_id)
    self.joins(:transactions)
    .joins(:invoice_items)
    .joins(:invoices)
    .select("merchants.id as id, merchants.name as name, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .where("merchants.id = ?", "#{merchant_id}")
    .group(:name, :id)
  end

  def self.top_revenue(quantity)
    joins(:transactions, :invoice_items)
    .select("merchants.id as id, merchants.name as name, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:name, :id)
    .order(revenue: :desc)
    .where("invoices.status = ? and transactions.result = ?", 'shipped', 'success')
    .limit(quantity)
  end
end
