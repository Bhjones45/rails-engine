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
      limit_per_page = 20
    else
      limit_per_page = params[:per_page].to_i
    end

    items = Item.offset((page - 1) * limit_per_page).limit(limit_per_page)
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.new(item_params)

    if item.save
      render json: ItemSerializer.new(item), status: 201
    end
  end

  def update
    item = Item.find(params[:id])

    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: {
               message: 'Not Found',
               errors: ["Item with id##{params[:id]} could not be found"]
      }
    end
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  def find_all
    items = Item.search(params[:name])
    if items.empty?
      render json: { data: [] }
    else
      render json: ItemSerializer.new(items)
    end
  end

  private
    def item_params
      params.permit(:name, :description, :unit_price, :merchant_id)
    end
end
