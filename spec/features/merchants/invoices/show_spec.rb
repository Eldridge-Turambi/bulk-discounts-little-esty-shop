require 'rails_helper'

RSpec.describe 'merchant invoices show page' do

  it 'visits merchant inoice shopw page and displays information of that invoice' do
    merchant = Merchant.create!(name: 'merchant name')
    customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice = Invoice.create!(customer_id: customer.id, status: 'completed')

    visit merchant_invoice_path(merchant, invoice)

    within '.header' do
      expect(page).to have_content(invoice.id)
      expect(page).to have_content(invoice.status)
      expect(page).to have_content(invoice.created_at.strftime("%A %B %d %Y"))
      expect(page).to have_content(customer.first_name)
      expect(page).to have_content(customer.last_name)
    end
  end
  it 'lists items for an invoice and their attributes' do
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
    invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 7,
                                         unit_price: 100)
    invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_2.id, quantity: 3,
                                         unit_price: 200)
    invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_3.id, quantity: 2,
                                         unit_price: 300)
    invoice_item_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 2,
                                         unit_price: 400)

    invoice_item_5 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_5.id, quantity: 1,
                                         unit_price: 700)

    visit merchant_invoice_path(merchant, invoice)

    within '.header' do
      expect(page).to have_content("Invoice ##{invoice.id}")
    end

    within '.invoice-items' do
      expect(page).to have_content(item_1.name)
      expect(page).to have_content(item_2.name)
      expect(page).to have_content(item_3.name)
      expect(page).to have_content(item_4.name)
      expect(page).to have_content((item_1.unit_price / 100.to_f).to_s.prepend('$').ljust(5, '0'))
      expect(page).to have_content((item_2.unit_price / 100.to_f).to_s.prepend('$').ljust(5, '0'))
      expect(page).to have_content((item_3.unit_price / 100.to_f).to_s.prepend('$').ljust(5, '0'))
      expect(page).to have_content((item_4.unit_price / 100.to_f).to_s.prepend('$').ljust(5, '0'))
      expect(page).to have_content(invoice_item_1.status)
      expect(page).to have_content(invoice_item_2.status)
      expect(page).to have_content(invoice_item_3.status)
      expect(page).to have_content(invoice_item_4.status)
      expect(page).to_not have_content(item_5.name)
    end
  end
  it 'lists the total revenue for the invoice' do
    merchant = Merchant.create!(name: 'merchant name')
    not_included_merchant = Merchant.create!(name: 'merchant name')
    customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice = Invoice.create!(customer_id: customer.id, status: 'completed')
    invoice_2 = Invoice.create!(customer_id: customer.id, status: 'completed')
    item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description',
                          unit_price: 13635)
    item_2 = Item.create!(merchant_id: merchant.id, name: 'widget-2', description: 'widget description',
                          unit_price: 23324)
    item_3 = Item.create!(merchant_id: merchant.id, name: 'widget-3', description: 'widget description',
                          unit_price: 34873)
    item_4 = Item.create!(merchant_id: merchant.id, name: 'widget-4', description: 'widget description',
                          unit_price: 2196)
    item_5 = Item.create!(merchant_id: not_included_merchant.id, name: 'widget-20', description: 'widget description',
                          unit_price: 79140)
    invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 7,
                                         unit_price: 13635)
    invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_2.id, quantity: 3,
                                         unit_price: 23324)
    invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_3.id, quantity: 2,
                                         unit_price: 34873)
    invoice_item_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 2,
                                         unit_price: 2196)

    invoice_item_5 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_5.id, quantity: 1,
                                         unit_price: 79140)

    visit merchant_invoice_path(merchant, invoice)

    within '.revenue' do
      expect(page). to have_content("Total Revenue: #{(invoice.total_revenue / 100.to_f).to_s.prepend('$').insert(2, ',')}")
    end
  end
  it 'allows merchant to update an invoice_item status' do
    merchant = Merchant.create!(name: 'merchant name')
    not_included_merchant = Merchant.create!(name: 'merchant name')
    customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice = Invoice.create!(customer_id: customer.id, status: 'completed')
    invoice_2 = Invoice.create!(customer_id: customer.id, status: 'completed')
    item_1 = Item.create!(merchant_id: merchant.id, name: 'widget-1', description: 'widget description',
                          unit_price: 13635)
    item_2 = Item.create!(merchant_id: merchant.id, name: 'widget-2', description: 'widget description',
                          unit_price: 23324)
    item_3 = Item.create!(merchant_id: merchant.id, name: 'widget-3', description: 'widget description',
                          unit_price: 34873)
    item_4 = Item.create!(merchant_id: merchant.id, name: 'widget-4', description: 'widget description',
                          unit_price: 2196)
    item_5 = Item.create!(merchant_id: not_included_merchant.id, name: 'widget-20', description: 'widget description',
                          unit_price: 79140)
    invoice_item_1 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_1.id, quantity: 7,
                                         unit_price: 13635)
    invoice_item_2 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_2.id, quantity: 3,
                                         unit_price: 23324)
    invoice_item_3 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_3.id, quantity: 2,
                                         unit_price: 34873)
    invoice_item_4 = InvoiceItem.create!(invoice_id: invoice.id, item_id: item_4.id, quantity: 2,
                                         unit_price: 2196)

    invoice_item_5 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_5.id, quantity: 1,
                                         unit_price: 79140)

    visit merchant_invoice_path(merchant, invoice)
    within ".invoice-item-#{invoice_item_1.id}" do
      select("shipped", from: 'invoice_item_status')
      click_button "Update Invoice item"

      invoice_item_1.reload

      expect(invoice_item_1.status).to eq("shipped")
    end
  end



#########################################################################################


  describe 'Bulk Discounts Stories' do

    it 'Shows merchant discounted revenue for merchant from this invoice not including discounts' do
      merchant1 = Merchant.create!(name: 'merchant1')

      discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)

      customer1 = Customer.create!(first_name: 'first_name1', last_name: 'last_name1')

      invoice1 = Invoice.create!(customer_id: customer1.id, status: 'completed')

      item1 = Item.create!(merchant_id: merchant1.id, name: 'item1', description: 'widget description', unit_price: 14000)

      invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 10, unit_price: 14000)
      visit merchant_invoice_path(merchant1, invoice1)


      within '.discounted_revenue' do
        expect(page).to have_content("Discounted Revenue: $1,120.00")
      end
    end

    it 'sees a link to the show page for the bulk discount that was applied' do
      merchant1 = Merchant.create!(name: 'merchant1')

      discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)

      customer1 = Customer.create!(first_name: 'first_name1', last_name: 'last_name1')

      invoice1 = Invoice.create!(customer_id: customer1.id, status: 'completed')
      #invoice2 = Invoice.create!(customer_id: customer1.id, status: 'completed')

      item1 = Item.create!(merchant_id: merchant1.id, name: 'item1', description: 'widget description', unit_price: 14000)
      item2 = Item.create!(merchant_id: merchant1.id, name: 'item2', description: 'widget description', unit_price: 14000)

      invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 10, unit_price: 14000)
      invoice_item2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 5, unit_price: 14000)

      visit merchant_invoice_path(merchant1, invoice1)
      click_link "#{item1.name} Discount Info"
      expect(current_path).to eq("/merchants/#{merchant1.id}/discounts/#{discount1.id}")
    end
  end
end
