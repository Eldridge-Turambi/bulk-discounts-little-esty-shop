require 'rails_helper'

RSpec.describe 'Merchant Discount Index Page' do

  it 'sees list of the merchants bild discounts including the percentage discount and quantity threshold' do
    merchant1 = Merchant.create!(name: 'merchant1')
    discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)
    discount2 = merchant1.bulk_discounts.create!(percentage: 0.25, threshold: 15)

    visit "/merchants/#{merchant1.id}/discounts"

    within '.merchant_discounts' do
      expect(page).to have_content(discount1.percentage * 100)
      expect(page).to have_content(discount2.percentage * 100)

      expect(page).to have_content(discount1.threshold)
      expect(page).to have_content(discount2.threshold)

      expect(page).to have_link("Details of #{discount1.percentage * 100} discount")
      click_link "Details of #{discount1.percentage * 100} discount"
      expect(current_path).to eq("/merchants/#{merchant1.id}/discounts/#{discount1.id}")
    end
  end

  it 'sees a link to create a new discount' do
    merchant1 = Merchant.create!(name: 'merchant1')

    visit "/merchants/#{merchant1.id}/discounts"

    within '.create_discount' do
      click_link "Create New Discount Here"

      expect(current_path).to eq("/merchants/#{merchant1.id}/discounts/new")
    end
  end
end
