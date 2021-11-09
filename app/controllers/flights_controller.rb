class FlightsController < ApplicationController
  before_action :fetch_search_parameters, only: %i[search]
  before_action :fetch_active_airports,
                only: %i[index search],
                unless: -> { params[:action] == 'search' && @flights_list.blank? }

  def index
    @flights_list = @flights
  end

  def search
    if @flights_list.blank?
      flash[:alert] = 'No flights found matching your choices, showing all flights!!'
      redirect_to flights_path
    else
      flash_success_search
      render 'index'
    end
  end

  private

  def fetch_active_airports
    @flights = Flight.all.includes(:departure_airport, :arrival_airport)
    @departing_ports = @flights.map { |f| [f.departure_airport.code, f.departure_airport_id] }.uniq
    @arriving_ports = @flights.map { |f| [f.arrival_airport.code, f.arrival_airport_id] }.uniq
  end

  def fetch_search_parameters
    @flights_list = Flight.search(
      params[:departure_code],
      params[:arrival_code],
      Date.parse(params[:flight_date]),
      params[:user_passenger_count].to_i
    )
  end

  def flash_success_search
    flash.now[:notice] =
      "Listing flights from #{@flights_list.first.departure_airport.code},
      to #{@flights_list.first.arrival_airport.code},
      On #{Date.parse(params[:flight_date]).strftime('%m-%d-%Y')},
      with room for #{params[:user_passenger_count]} passengers."
  end
end
