class BookingsController < ApplicationController
  before_action :flight_choice_params, only: %i[new]

  def new
    @flight_choice = Flight.where(id: params[:flight_id])
    @passenger_count = params[:passenger_count]
  end

  def create

  end

  private

  def flight_choice_params
    params.permit(:flight_id, :passenger_count)
  end
end
