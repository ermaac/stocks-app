module Marketplace
  class ShareOrderSerializer
    include Alba::Resource

    attributes :id, :price_per_share, :shares_amount, :organization_id
  end
end
