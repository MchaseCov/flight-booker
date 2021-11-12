class Passenger < ApplicationRecord
  # Passenger data structure
  #
  # id: :integer
  # name: :string
  # email: :string
  # booking_id: integer
  # timestamps: :integers

  # Validations

  # Associations
  belongs_to :booking, inverse_of: :passengers
  has_many :flights, through: :booking
end
