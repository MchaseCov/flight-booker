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

  # Searches based on user params. If results, will evaluate accuracy. Else, returns blank
  def self.search(departure_search_input, arrival_search_input, date_search_input, tickets_search_input)
    similar_flights = Flight.where(
      departure_airport: departure_search_input,
      arrival_airport: arrival_search_input,
      passenger_count: ...(100 - tickets_search_input)
    )
    if similar_flights.present?
      search_results_evaluation(similar_flights, date_search_input)
    else
      similar_flights
    end
  end

  # Evaluates if the results are a match by date or not
  def self.search_results_evaluation(similar_flights, date_search_input)
    matching_flight = similar_flights.where(departure_time: date_search_input.beginning_of_day..date_search_input.end_of_day)
    if matching_flight.present?
      matching_flight_success_message(matching_flight)
    else
      similar_flights_success_message(similar_flights)
    end
  end

  # Passes success message to controller along with resulting AR relation
  def self.matching_flight_success_message(matching_flight)
    [matching_flight, { notice:
      "Success! We found a flight from #{matching_flight.first.departure_airport.code}
      to #{matching_flight.first.arrival_airport.code}
      on #{matching_flight.first.departure_time.strftime('%m-%d-%Y')},
      with room for #{100 - matching_flight.first.passenger_count} passengers." }]
  end

  # Passes semi-success message to controller along with resulting AR relation
  def self.similar_flights_success_message(similar_flights)
    [similar_flights, { notice:
      "No flights found matching your date, but we found
      #{ActionController::Base.helpers.pluralize(similar_flights.count, 'flight')}
      from #{similar_flights.first.departure_airport.code}
      to #{similar_flights.first.arrival_airport.code} on other dates." }]
  end

  private

  def add_new_passengers_to_total
    total_passengers = :passenger_count # + ?
    Flight.assign_attributes(passenger_count: total_passengers)
  end
end
