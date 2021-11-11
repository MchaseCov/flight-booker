class FlightsController < ApplicationController
  before_action :fetch_search_parameters, only: %i[search]
  before_action :fetch_active_airports,
                only: %i[index search],
                unless: -> { params[:action] == 'search' && @search_results.blank? }
  # Index page
  def index
    @flights_list = @flights
  end

  # Logic for determining the results of a search and returning the appropriate result
  def search
    if @search_results.blank?
      redirect_to flights_path, alert: 'No flights found matching your choices, showing all flights.'
    else
      flash[:notice] = @search_results.last[:notice]
      render 'index'
    end
  end

  # Limits arrival airport options to the respective departing airport's outgoing flights
  # Used along with packs/flights.js && views/flights/update_airports.js.erb
  def update_airports
    @arrival_airports = Flight.all.where(departure_airport_id: params[:departure_airport_id]).uniq(&:arrival_airport_id)
    respond_to do |format|
      format.js
    end
  end

  private

  # Fetches flights and airports associated them
  def fetch_active_airports
    @flights = Flight.all.includes(:departure_airport, :arrival_airport)
    @departing_ports = @flights
    @arrival_airports = @flights.where(id: 1)
  end

  # Queries Flight with user params
  def fetch_search_parameters
    @search_results = Flight.search(
      params[:departure_code],
      params[:arrival_code],
      Date.parse(params[:flight_date]),
      params[:user_passenger_count].to_i
    )
    @flights_list = @search_results.first
  end
end
