class Platform::User < ApplicationRecord
  extend Enumerize

  ROLES = %i[owner employee]

  enumerize :role, in: ROLES

  belongs_to :organization
end
