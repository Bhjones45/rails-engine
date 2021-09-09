class Api::V1::RevenueController < ApplicationController

  def unshipped_orders_revenue
    if params[:quantity] == ''
      render json: { data: [] }, status: 400
    elsif params[:quantity].present? && params[:quantity].to_i.zero?
      render json: { data: [] }, status: 400
    else
      invoices = Invoice.potential_revenue(params[:quantity])
    end

    render json: UnshippedOrdersSerializer.new(invoices)
  end

  def merchant_total_revenue
    merchant = Merchant.merchant_revenue(params[:id])
    render json: MerchantTotalRevenueSerializer.new(merchant)
  end


end
