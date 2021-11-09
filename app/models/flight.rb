class Flight < ApplicationRecord
  # Validation
  validates :passenger_count, numericality: { less_than_or_equal_to: 100, only_integer: true }

  # Associations

  belongs_to :departure_airport, class_name: 'Airport'
  belongs_to :arrival_airport, class_name: 'Airport'

  # Methods

  def self.departure_dates
    Flight.select(:departure_time)
  end

  def departure_date_formatted
    departure_time.strftime('%m-%d-%Y')
  end

  def self.search(departure_code, arrival_code, flight_date, user_passenger_count)
    if departure_code && arrival_code && flight_date && user_passenger_count
      Flight.where(
        departure_airport: departure_code,
        arrival_airport: arrival_code,
        departure_time: flight_date.beginning_of_day..flight_date.end_of_day,
        passenger_count: ...(100 - user_passenger_count)
      )
    else
      Flight.all
    end
  end

end
