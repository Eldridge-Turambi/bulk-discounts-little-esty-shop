require 'rails_helper'

RSpec.describe Invoice, type: :model do

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe '#merchants_invoices' do
    it "returns merchants invoices" do
      merch_1 = Merchant.create!(name: "Shop Here")

      item_1 = Item.create!(name:"jumprope", description:"Pink and sparkly.", unit_price:600, merchant_id:"#{merch_1.id}")
      item_2 = Item.create!(name:"hula hoop", description:"Get your groove on!", unit_price:700, merchant_id:"#{merch_1.id}")

      cust_1 = Customer.create!(first_name:"Hannah", last_name:"Warner")

      invoice_1 = Invoice.create!(customer_id:"#{cust_1.id}", status:1)
      invoice_2 = Invoice.create!(customer_id:"#{cust_1.id}", status:1)
      invoice_3 = Invoice.create!(customer_id:"#{cust_1.id}", status:1)

      invoice_item_1 = InvoiceItem.create!(invoice_id:"#{invoice_1.id}", item_id:"#{item_1.id}", status: 2, quantity:1, unit_price:600)
      invoice_item_2 = InvoiceItem.create!(invoice_id:"#{invoice_2.id}", item_id:"#{item_2.id}", status: 2, quantity:1, unit_price:700)
      invoice_item_3 = InvoiceItem.create!(invoice_id:"#{invoice_3.id}", item_id:"#{item_2.id}", status: 2, quantity:1, unit_price:700)
      invoice_item_4 = InvoiceItem.create!(invoice_id:"#{invoice_1.id}", item_id:"#{item_1.id}", status: 2, quantity:1, unit_price:600)
      expect(Invoice.merchants_invoices(merch_1)).to contain_exactly(invoice_1, invoice_2, invoice_3)
    end
  end

  describe '#total_revenue' do
    it 'returns total revenue for an invoice' do
      merchant = Merchant.create!(name: 'merchant name')
      not_included_merchant = Merchant.create!(name: 'merchant name')
      customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
      item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description',
                            unit_price: 100)
      item_2 = Item.create!(merchant_id: merchant.id, name: 'widget-2', description: 'widget description',
                            unit_price: 200)
      item_3 = Item.create!(merchant_id: merchant.id, name: 'widget-3', description: 'widget description',
                            unit_price: 300)
      item_4 = Item.create!(merchant_id: merchant.id, name: 'widget-4', description: 'widget description',
                            unit_price: 400)
      item_5 = Item.create!(merchant_id: not_included_merchant.id, name: 'widget-20', description: 'widget description',
                            unit_price: 40440)

      invoice = Invoice.create!(customer_id: customer.id, status: 'completed')
      invoice_2 = Invoice.create!(customer_id: customer.id, status: 'completed')
      invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 7, unit_price: 100)
      invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_2.id, quantity: 3, unit_price: 200)
      invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_3.id, quantity: 2, unit_price: 300)
      invoice_item_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 2, unit_price: 400)

      invoice_item_5 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_5.id, quantity: 1, unit_price: 700)
      actual = invoice.total_revenue
      expected = 2700
      expect(actual).to eq(expected)
    end
  end

  describe '#incomplete_invoices' do
    it "returns incomplete invoices" do
      cust_1 = Customer.create!(first_name:"Hannah", last_name:"Warner")

      invoice_1 = Invoice.create!(customer_id:"#{cust_1.id}", status: "in progress")
      invoice_2 = Invoice.create!(customer_id:"#{cust_1.id}", status:"completed")
      invoice_3 = Invoice.create!(customer_id:"#{cust_1.id}", status:"in progress", created_at:DateTime.yesterday)

      expect(Invoice.incomplete_invoices.to_a).to eq([invoice_3, invoice_1])
    end
  end

  describe '#discounted_revenue' do
    it 'returns total revenue for an invoice' do
      merchant1 = Merchant.create!(name: 'merchant1')

      discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)
      discount2 = merchant1.bulk_discounts.create!(percentage: 0.25, threshold: 15)

      merchant2 = Merchant.create!(name: 'merchant2')

      customer1 = Customer.create!(first_name: 'first_name1', last_name: 'last_name1')

      item1 = merchant1.items.create!(name: 'item1', description: 'description1', unit_price: 100)
      item2 = merchant1.items.create!(name: 'item2', description: 'description2', unit_price: 100)
      item3 = merchant1.items.create!(name: 'item3', description: 'description3', unit_price: 100)
      item4 = merchant1.items.create!(name: 'item4', description: 'description4', unit_price: 100)
      item5 = merchant2.items.create!(name: 'item5', description: 'description5', unit_price: 100)


      invoice1 = Invoice.create!(customer_id: customer1.id, status: 'completed')
      invoice2 = Invoice.create!(customer_id: customer1.id, status: 'completed')

      invoice_item_1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 10, unit_price: 100)
      invoice_item_2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 10, unit_price: 200)
      invoice_item_3 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item3.id, quantity: 10, unit_price: 300)
      invoice_item_4 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item4.id, quantity: 15, unit_price: 400)
      invoice_item_5 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: item5.id, quantity: 15, unit_price: 700)

      actual = invoice1.discounted_revenue
      #calculator calculation done with calculator multiple times
      expected = 9300.0

      expect(actual).to eq(expected)
    end
  end
end
