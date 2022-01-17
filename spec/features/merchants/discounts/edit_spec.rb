require 'rails_helper'

RSpec.describe 'Discount Edit Page' do

  it 'displays a form with prepopulated attributes of the exisiting Discount' do
    merchant1 = Merchant.create!(name: 'merchant1')
    discount1 = merchant1.bulk_discounts.create!(percentage: 0.20, threshold: 10)

    visit "/merchants/#{merchant1.id}/discounts/#{discount1.id}/edit"

    within '.edit_discount' do

      expect(page).to have_field(:percentage, with: discount1.percentage)
      expect(page).to have_field(:threshold, with: discount1.threshold)

      expect(page).to_not have_content("40.0%")
      expect(page).to_not have_content(20)

      fill_in 'percentage', with: 0.40
      fill_in 'threshold', with: 20

      click_button 'Update This Discount'
      
      expect(current_path).to eq("/merchants/#{merchant1.id}/discounts/#{discount1.id}")
    end

    within '.discount_show' do
      expect(page).to have_content("40.0%")
      expect(page).to have_content(20)
    end
  end
end
