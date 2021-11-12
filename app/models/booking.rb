class Booking < ApplicationRecord
  # Booking data structure
  #
  # id: :integer
  # flight_id: :integer
  # timestamps: :integers

  # Callbacks
  after_commit :update_flight_passenger_total
  after_destroy :restore_flight_passenger_total
  # Validations

  # Associations
  belongs_to :flight
  has_many :passengers, dependent: :destroy, inverse_of: :booking
  accepts_nested_attributes_for :passengers

  # Methods

  def update_flight_passenger_total
    total_passengers = flight.passenger_count + passengers.count
    flight.assign_attributes(passenger_count: total_passengers)
  end

  def restore_flight_passenger_total
    total_passengers = flight.passenger_count - passengers.count
    flight.assign_attributes(passenger_count: total_passengers)
  end
end
