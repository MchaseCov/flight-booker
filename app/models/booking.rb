class Booking < ApplicationRecord
  # Booking data structure
  #
  # id: :integer
  # flight_id: :integer
  # timestamps: :integers

  # Callbacks
  after_commit :update_flight_passenger_total
  after_destroy_commit :restore_flight_passenger_total
  # Validations

  # Associations
  belongs_to :flight
  has_many :passengers, dependent: :destroy, inverse_of: :booking
  accepts_nested_attributes_for :passengers

  # Methods

  def update_flight_passenger_total
    f = Flight.find(self.flight_id)
    f.passenger_count += self.passengers.count
    f.save
  end

  def restore_flight_passenger_total
    f = Flight.find(flight_id)
    f.passenger_count -= passengers.count
    f.save
  end
end
