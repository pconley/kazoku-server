class Membership < ApplicationRecord
  belongs_to :person
  belongs_to :family
end