class BookingsController < ApplicationController
  before_action :fetch_params, only: %i[new create]

  def new
    @booking = Booking.new
    @flight_choice = Flight.find(params[:flight_choice])
    @passenger_count = params[:passenger_count].to_i
    @passenger_count.times { @booking.passengers.build }
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      flash[:notice] = 'SUCCESS MESSAGE'
      redirect_to @booking
    else
      flash.now[:alert] = @booking.errors.full_messages
      render :new
    end
  end

  def show
    @booking = Booking.find(params[:id])
  end

  private

  def booking_params
    params.require(:booking).permit(:flight_id, passengers_attributes: %I[id name email])
  end

  def fetch_params
    @flight_choice = Flight.find(params[:flight_choice])
    @passenger_count = params[:passenger_count].to_i
  end
end
