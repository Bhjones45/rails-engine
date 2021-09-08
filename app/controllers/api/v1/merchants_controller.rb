class Api::V1::MerchantsController < ApplicationController
  def index
    if params[:page].nil?
      page = params.fetch(:page, 1).to_i
    elsif params[:page].to_i <= 0
      page = 1
    else
      page = params[:page].to_i
    end

    if params[:per_page].nil?
      limit = 20
    else
      limit = params[:per_page].to_i
    end

    merchants = Merchant.offset((page - 1) * limit).limit(limit)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)

  end

  def find
    merchant = Merchant.search(params[:name])

    if merchant.nil?
      render json: { data: [] }, status: 400
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
