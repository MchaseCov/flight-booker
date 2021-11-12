class Passenger < ApplicationRecord
  # Passenger data structure
  #
  # id: :integer
  # name: :string
  # email: :string
  # timestamps: :integers

  # Validations

  # Associations
  belongs_to :bookings
  has_many :flights, through: :bookings
end
