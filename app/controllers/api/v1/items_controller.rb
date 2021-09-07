class Api::V1::ItemsController < ApplicationController
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

    items = Item.offset((page - 1) * limit).limit(limit)
    render json: ItemSerializer.new(items)
  end
end
