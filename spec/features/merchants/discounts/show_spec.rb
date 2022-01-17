require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show Page' do

  it 'visits bulk discount show page and sees the discount quantity threshold and percentage discount' do
    merchant1 = Merchant.create!(name: 'merchant1')
    discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)

    visit "/merchants/#{merchant1.id}/discounts/#{discount1.id}"

    within '.discount_show' do
      expect(page).to have_content(discount1.percentage * 100)
      expect(page).to have_content(discount1.threshold)
    end
  end

  it 'sees a link to edit merchant bulk discount' do
    merchant1 = Merchant.create!(name: 'merchant1')
    discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)

    visit "/merchants/#{merchant1.id}/discounts/#{discount1.id}"

    within '.discount_show' do
      click_link "Edit Discount"
      expect(current_path).to eq("/merchants/#{merchant1.id}/discounts/#{discount1.id}/edit")
    end
  end
end
