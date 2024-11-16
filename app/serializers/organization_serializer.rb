class OrganizationSerializer
  include Alba::Resource

  attributes :id, :name, :total_shares_amount, :available_shares_amount
end
