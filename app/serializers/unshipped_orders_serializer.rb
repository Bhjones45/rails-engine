class UnshippedOrdersSerializer
  include JSONAPI:: Serializer

  set_type 'unshipped_order'
  attributes :potential_revenue
end
