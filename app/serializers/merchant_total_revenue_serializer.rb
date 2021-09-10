class MerchantTotalRevenueSerializer
  include JSONAPI::Serializer
  attributes :name

  set_type "merchant_name_revenue"
  attributes :revenue
end
