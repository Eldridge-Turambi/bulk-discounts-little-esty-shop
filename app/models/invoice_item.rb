class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  enum status: ["pending", "packaged", "shipped"]


  def single_item_revenue
    quantity * unit_price
  end

  def best_discount
    all_discounts = item.merchant.bulk_discounts
    the_right_discount =
    all_discounts
    .where("#{self.quantity} >= bulk_discounts.threshold")
    .order(percentage: :desc)
    .first
    the_right_discount
  end

  def invoice_item_discount_revenue
    if best_discount == nil
      single_item_revenue
    else
      single_item_revenue - (best_discount.percentage * single_item_revenue)
    end
  end
end

# def best_discount_with_ruby
#   all_discounts = item.merchant.bulk_discounts
#
#   valid_discounts = all_discounts.select do |discount|
#     self.quantity >= discount.threshold
#   end
#
#   selected_discount = valid_discounts.max_by do |discount|
#     discount.percentage
#   end
#   selected_discount
# end
