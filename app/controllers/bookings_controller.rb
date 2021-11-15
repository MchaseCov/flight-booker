class BookingsController < ApplicationController
  before_action :set_booking_attributes, only: %i[new create]

  def new
    @booking = @flight_choice.bookings.new
    @passenger_count.times { @booking.passengers.build }
    @departure_airport = @flight_choice.departure_airport.code
    @arrival_airport = @flight_choice.arrival_airport.code
    @departure_time = @flight_choice.departure_time.strftime('on %m-%d-%Y, at %H:%M')
    @arrival_time = (@flight_choice.departure_time + @flight_choice.duration * 60 * 60)
                    .strftime('on %m-%d-%Y, at %H:%M')
  end

  def create
    @booking = @flight_choice.bookings.new(booking_params)
    if @booking.save
      redirect_to [@flight, @booking], notice: 'Signed you up!'
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
