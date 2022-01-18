require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe 'Model Methods' do
    it '#single_item_revenue' do
      merchant1 = Merchant.create!(name: 'merchant1')

      discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)
      discount2 = merchant1.bulk_discounts.create!(percentage: 0.30, threshold: 15)
      discount3 = merchant1.bulk_discounts.create!(percentage: 0.40, threshold: 20)

      customer1 = Customer.create!(first_name: 'first_name1', last_name: 'last_name1')

      invoice1 = Invoice.create!(customer_id: customer1.id, status: 'completed')

      item1 = Item.create!(merchant_id: merchant1.id, name: 'item1', description: 'widget description', unit_price: 14000)

      invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 20, unit_price: 10000)

      expect(invoice_item1.single_item_revenue).to eq(200000)
    end

    it '#best discount' do
      merchant1 = Merchant.create!(name: 'merchant1')

      discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)
      discount2 = merchant1.bulk_discounts.create!(percentage: 0.30, threshold: 15)
      discount3 = merchant1.bulk_discounts.create!(percentage: 0.40, threshold: 20)

      customer1 = Customer.create!(first_name: 'first_name1', last_name: 'last_name1')

      invoice1 = Invoice.create!(customer_id: customer1.id, status: 'completed')

      item1 = Item.create!(merchant_id: merchant1.id, name: 'item1', description: 'widget description', unit_price: 14000)

      invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 20, unit_price: 10000)

      expect(invoice_item1.best_discount).to eq(discount3)
    end

    describe '#invoice_item_revenue' do
      it '#invoice_item_discount_revenue' do
        merchant1 = Merchant.create!(name: 'merchant1')

        discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)
        discount2 = merchant1.bulk_discounts.create!(percentage: 0.30, threshold: 15)
        discount3 = merchant1.bulk_discounts.create!(percentage: 0.40, threshold: 20)

        customer1 = Customer.create!(first_name: 'first_name1', last_name: 'last_name1')

        invoice1 = Invoice.create!(customer_id: customer1.id, status: 'completed')

        item1 = Item.create!(merchant_id: merchant1.id, name: 'item1', description: 'widget description', unit_price: 14000)

        invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 20, unit_price: 10000)

        expect(invoice_item1.invoice_item_discount_revenue).to eq(120000.0)
      end

      it 'calculates #invoice_item_best_revenue when there is no applicable disounts' do
        merchant1 = Merchant.create!(name: 'merchant1')

        discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)
        discount2 = merchant1.bulk_discounts.create!(percentage: 0.30, threshold: 15)
        discount3 = merchant1.bulk_discounts.create!(percentage: 0.40, threshold: 20)

        customer1 = Customer.create!(first_name: 'first_name1', last_name: 'last_name1')

        invoice1 = Invoice.create!(customer_id: customer1.id, status: 'completed')

        item1 = Item.create!(merchant_id: merchant1.id, name: 'item1', description: 'widget description', unit_price: 14000)

        invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 5, unit_price: 10000)

        expect(invoice_item1.invoice_item_discount_revenue).to eq(50000)
      end
    end

  end
end
