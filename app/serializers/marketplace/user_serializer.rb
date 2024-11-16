module Marketplace
  class UserSerializer
    include Alba::Resource

    attributes :id, :username
  end
end
