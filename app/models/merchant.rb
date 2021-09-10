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
    select('merchants.id, merchants.name, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .joins('INNER JOIN invoices ON invoices.merchant_id = merchants.id')
    .joins('INNER JOIN transactions ON invoices.id = transactions.invoice_id')
    .joins('INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id')
    .where(transactions: { result: 'success' })
    .where(invoices: { status: 'shipped' })
    .group(:id)
    .order(revenue: :desc)
    .limit(quantity)
  end
end
