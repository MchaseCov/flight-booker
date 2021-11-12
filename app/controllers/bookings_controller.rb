class BookingsController < ApplicationController
  before_action :set_booking_attributes, only: %i[new create]

  def new
    @booking = @flight_choice.bookings.new
    @passenger_count.times { @booking.passengers.build }
  end

  def create
    @booking = @flight_choice.bookings.new(booking_params)
    if @booking.save
      redirect_to [@flight, @booking], notice: 'SUCCESS MESSAGE'
    else
      render :new, alert: @booking.errors.full_messages
    end
  end

  def show
    @booking = Booking.find(params[:id])
  end

  private

  def booking_params
    params.require(:booking).permit(passengers_attributes: %I[id name email])
  end

  def set_booking_attributes
    @flight_choice = Flight.find(params[:flight_id])
    @passenger_count = params[:tickets].present? ? params[:tickets].to_i : booking_params.to_h.length
  end
end
