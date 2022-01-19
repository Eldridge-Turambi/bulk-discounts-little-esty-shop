class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: ["in progress", "completed", "cancelled"]

  def self.merchants_invoices(merchant)
    joins(:invoice_items, :items).where(items: { merchant_id: merchant.id }).distinct(:invoice_id)
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def self.incomplete_invoices
    where(status: "in progress").order(created_at: :asc).distinct(:id)
  end

  def discounted_revenue
    invoice_items.sum do |invoice_item|
      invoice_item.invoice_item_discount_revenue
    end
  end
end
