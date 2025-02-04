require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page' do

  it 'shows customer and status information for the invoice' do
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

    visit "/admin/invoices/#{invoice_1.id}"

    expect(page).to have_content("Invoice ID: #{invoice_1.id}")
    expect(page).to have_content("Invoice Status: #{invoice_1.status}")
    expect(page).to have_content(invoice_1.created_at.strftime("%A, %B %d, %Y"))
    expect(page).to have_content(cust_1.first_name)
    expect(page).to have_content(cust_1.last_name)
  end

  it 'shows Item information for the the show page' do
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

    visit "/admin/invoices/#{invoice_1.id}"

    within ".invoice" do
      expect(page).to have_content(item_1.name)
      expect(page).to_not have_content(item_2.name)
      expect(page).to have_content(invoice_item_1.quantity)
      expect(page).to have_content(invoice_item_1.unit_price)
      expect(page).to_not have_content(invoice_item_3.unit_price)
      expect(page).to have_content(invoice_item_1.status)
    end
  end

  it 'shows total revenue for generated from an invoice' do
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

    visit "/admin/invoices/#{invoice_1.id}"

    within ".total_revenue" do
    expect(page).to have_content("Total Revenue: #{invoice_1.total_revenue.to_s.prepend('$').insert(2, '.')}")
    end
  end

  it 'uses a select field to update invoice status' do
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

    visit "/admin/invoices/#{invoice_1.id}"

      expect(page).to have_content(invoice_1.status)
      select 'completed', from: "Status"
      click_button "Update Status"
      expect(current_path).to eq(admin_invoices_path(:id))
      expect(invoice_1.status).to eq('completed')
  end



  describe 'Bulk Discount user stories' do
    it 'sees the total revenue AND the discounted revenue from that invoice' do
      merchant1 = Merchant.create!(name: 'merchant1')
      merchant2 = Merchant.create!(name: 'merchant2')

      discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)
      discount2 = merchant1.bulk_discounts.create!(percentage: 0.50, threshold: 50)

      customer1 = Customer.create!(first_name: 'first_name1', last_name: 'last_name1')

      invoice1 = Invoice.create!(customer_id: customer1.id, status: 'completed')

      item1 = Item.create!(merchant_id: merchant1.id, name: 'item1', description: 'widget description', unit_price: 140)
      item2 = Item.create!(merchant_id: merchant1.id, name: 'item2', description: 'widget description', unit_price: 140)
      item3 = Item.create!(merchant_id: merchant2.id, name: 'item2', description: 'widget description', unit_price: 140)

      invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 10, unit_price: 140)
      invoice_item2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 5, unit_price: 140)
      invoice_item3 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 50, unit_price: 140)
      invoice_item4 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item3.id, quantity: 10, unit_price: 140)

      visit "/admin/invoices/#{invoice1.id}"
      within '.total_revenue' do
        expect(page).to have_content('Total Revenue: $105.00')
      end

      within '.discounted_revenue' do
        expect(page).to have_content('Discounted Revenue: $67.20')
      end
    end
  end

end
