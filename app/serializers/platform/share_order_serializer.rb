module Platform
  class ShareOrderSerializer
    include Alba::Resource

    attributes :id, :price_per_share, :shares_amount, :state

    one :user, key: "buyer", resource: Marketplace::UserSerializer
  end
end
