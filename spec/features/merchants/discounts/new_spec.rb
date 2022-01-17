require 'rails_helper'

RSpec.describe 'Create/New Discount page' do

  it 'displays a form to create a new discount' do
    merchant1 = Merchant.create!(name: 'merchant1')
    discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)
    discount2 = merchant1.bulk_discounts.create!(percentage: 0.25, threshold: 15)

    visit "/merchants/#{merchant1.id}/discounts/new"

    within '.new_discount' do
      fill_in "percentage", with: 0.50
      fill_in "threshold", with: 50

      click_button "Create Discount"

      expect(current_path).to eq("/merchants/#{merchant1.id}/discounts")
    end
    expect(page).to have_content("50.0%")
  end
end
