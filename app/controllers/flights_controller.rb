class FlightsController < ApplicationController
  before_action :fetch_search_parameters, only: %i[search]
  before_action :fetch_active_airports,
                only: %i[index search],
                unless: -> { params[:action] == 'search' && @search_results.blank? }
  # Index page. Change number to flights you want to display by default (in order of date)
  def index
    @filtered_flights = @flights.limit(0)
  end

  # Logic for determining the results of a search and returning the appropriate result
  def search
    if @search_results.blank?
      redirect_to flights_path, alert: 'Sorry! No flights found matching your airport choices!'
    else
      flash.now[:notice] = @search_results.last[:notice]
      render 'index'
    end
  end

  # Limits arrival airport options to the respective departing airport's outgoing flights
  # Used along with packs/flights.js && views/flights/update_airports.js.erb
  def update_airports
    @arrival_airports = Flight.where(departure_airport_id: params[:departure_airport_id]).uniq(&:arrival_airport_id)
    respond_to do |format|
      format.js
    end
  end

  private

  # Fetches flights and airports associated them
  def fetch_active_airports
    @flights = Flight.not_full.with_airports
    @depart_airports = @flights.map { |departing_airport|
      [departing_airport.departure_airport.code, departing_airport.departure_airport_id]
    }.uniq
    @arrival_airports = @flights.map { |arrival_airport|
      [arrival_airport.arrival_airport.code, arrival_airport.arrival_airport_id]
    }.uniq
    @dates = Flight.unique_dates
  end

  # Queries Flight with user params
  def fetch_search_parameters
    @search_results = Flight.search(
      params[:departure_search_input],
      params[:arrival_search_input],
      Date.strptime(params[:date_search_input], '%m-%d-%Y'),
      params[:tickets_search_input].to_i
    )
    @filtered_flights = @search_results.first
  end
end
