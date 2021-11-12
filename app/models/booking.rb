class Booking < ApplicationRecord
  # Booking data structure
  #
  # id: :integer
  # flight_id: :integer
  # timestamps: :integers

  # Validations

  # Associations
  belongs_to :flight
  has_many :passengers, dependent: :destroy, inverse_of: :booking
  accepts_nested_attributes_for :passengers
end
