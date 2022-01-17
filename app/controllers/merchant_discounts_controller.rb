class MerchantDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:id])
  end

  def show
    @discount = BulkDiscount.find(params[:discount_id])
    @merchant = Merchant.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:id])
  end

  def create
    merchant = Merchant.find(params[:id])
    merchant.bulk_discounts.create!(discount_params)
    redirect_to "/merchants/#{merchant.id}/discounts"
  end

  def destroy
    merchant = Merchant.find(params[:id])
    BulkDiscount.find(params[:discount_id]).destroy
    redirect_to "/merchants/#{merchant.id}/discounts"
  end

  def edit
    @discount = BulkDiscount.find(params[:discount_id])
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    discount = BulkDiscount.find(params[:discount_id])
    discount.update(discount_params)
    redirect_to "/merchants/#{merchant.id}/discounts/#{discount.id}"
  end


  private
  def discount_params
    params.permit(:percentage, :threshold)
  end

end
