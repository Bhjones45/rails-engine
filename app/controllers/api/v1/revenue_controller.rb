class Api::V1::RevenueController < ApplicationController
  MERCHANT_COUNT = Merchant.count

  def unshipped_orders_revenue
    if params[:quantity] == ''
      render json: { data: [] }, status: 400
    elsif params[:quantity].present? && params[:quantity].to_i.zero?
      render json: { data: [] }, status: 400
    else
      invoices = Invoice.potential_revenue(params[:quantity])
      render json: UnshippedOrdersSerializer.new(invoices)
    end

  end

  def merchant_total_revenue
    if !params[:quantity].present? || params[:quantity].to_i == 0
      render json: { data: [] }, status: 400
    elsif params[:quantity].to_i >= MERCHANT_COUNT
      merchants = Merchant.top_revenue(MERCHANT_COUNT)
      render json: MerchantTotalRevenueSerializer.new(merchants)
    else
      merchants = Merchant.top_revenue(params[:quantity].to_i)
      render json: MerchantTotalRevenueSerializer.new(merchants)
    end
  end
end
