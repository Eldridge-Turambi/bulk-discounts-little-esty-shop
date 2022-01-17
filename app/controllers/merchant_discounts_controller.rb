class MerchantDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:id])
  end

  def show
  end

  def new
    @merchant = Merchant.find(params[:id])
  end

  def create
    merchant = Merchant.find(params[:id])
    merchant.bulk_discounts.create!(discount_params)
    redirect_to "/merchants/#{merchant.id}/discounts"
  end

  private
  def discount_params
    params.permit(:percentage, :threshold)
  end

end
