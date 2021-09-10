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
      limit_per_page = 20
    else
      limit_per_page = params[:per_page].to_i
    end

    merchants = Merchant.offset((page - 1) * limit_per_page).limit(limit_per_page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)

  end

  def find
    merchant = Merchant.search(params[:name])

    if merchant.nil? || params[:name] == ''
      render json: { data: [] }, status: 200
    elsif merchant.empty?
      render json: { data: [] }, status: 200
    else
      render json: MerchantSerializer.new(merchant.first)
    end
  end
end
