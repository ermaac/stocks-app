class Marketplace::RegisterShareOrderJob
  include Sidekiq::Job

  sidekiq_options queue: :share_orders

  def perform(organization_id, shares_order_id)
    organization = Organization.find_by(id: organization_id)
    share_order = Marketplace::ShareOrder.find_by(id: shares_order_id)
    Marketplace::Actions::RegisterShareOrder.call(organization: organization, share_order: share_order)
  end
end
