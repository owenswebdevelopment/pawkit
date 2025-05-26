class UserFamily < ApplicationRecord
  belongs_to :family
  belongs_to :user
end
