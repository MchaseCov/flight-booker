class Flight < ApplicationRecord
  # Validation
  validates :passenger_count, numericality: { less_than_or_equal_to: 100, only_integer: true }

  # Associations

  belongs_to :departure_airport, class_name: 'Airport'
  belongs_to :arrival_airport, class_name: 'Airport'
end
