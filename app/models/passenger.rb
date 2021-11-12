class Passenger < ApplicationRecord
  # Validations

  # Associations
  belongs_to :bookings
  has_many :flights, through: :bookings
end
