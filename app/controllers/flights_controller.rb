class FlightsController < ApplicationController
  def index
    @flights = Flight.all.includes(:departure_airport, :arrival_airport)
  end
end
