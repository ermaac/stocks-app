class Platform::User < ApplicationRecord
  extend Enumerize

  has_secure_password

  ROLES = %i[owner employee]

  enumerize :role, in: ROLES

  belongs_to :organization
end
