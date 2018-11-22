class Hostname < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
