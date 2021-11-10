class FlightsController < ApplicationController
  before_action :fetch_search_parameters, only: %i[search]
  before_action :fetch_active_airports,
                only: %i[index search],
                unless: -> { params[:action] == 'search' && @flights_list.blank? }
  # Index page
  def index
    @flights_list = @flights
  end

  # Logic for determining the results of a search and returning the appropriate result
  def search
    if @flights_list.blank?
      fetch_similar_flights
      if @similar_flights_list.blank?
        redirect_to flights_path, alert: 'No flights found matching your choices, showing all flights.'
      else
        return_similar_fights
      end
    else
      return_successful_search
    end
  end

  # Limits arrival airport options to the respective departing airport's outgoing flights
  # Used along with packs/flights.js && views/flights/update_airports.js.erb
  def update_airports
    @arriving_ports = Flight.all.where('departure_airport_id = ?', params[:departure_airport_id])
    respond_to do |format|
      format.js
    end
  end

  private

  # Fetches flights and airports associated them
  def fetch_active_airports
    @flights = Flight.all.includes(:departure_airport, :arrival_airport)
    @departing_ports = @flights
    @arriving_ports = @flights.where('departure_airport_id = ?', Flight.first.departure_airport_id)
  end

  # Queries Flight for matching flight to params
  def fetch_search_parameters
    @flights_list = Flight.search(
      params[:departure_code],
      params[:arrival_code],
      Date.parse(params[:flight_date]),
      params[:user_passenger_count].to_i
    )
  end

  # Queries Flight for matching flight to param, excluding flight_date
  def fetch_similar_flights
    @similar_flights_list = Flight.search_similar(
      params[:departure_code],
      params[:arrival_code],
      params[:user_passenger_count].to_i
    )
  end

  # Returns match upon successful search
  def return_successful_search
    flash.now[:notice] =
      "Success! We found a flight
      from #{@flights_list.first.departure_airport.code},
      to #{@flights_list.first.arrival_airport.code},
      On #{Date.parse(params[:flight_date]).strftime('%m-%d-%Y')},
      with room for #{params[:user_passenger_count]} passengers."
    render 'index'
  end

  # Returns match upon a successful similar search
  def return_similar_fights
    flash.now[:alert] = 'No flights found matching your date, but we found flights on other dates.'
    fetch_active_airports
    @flights_list = @similar_flights_list
    render 'index'
  end
end
