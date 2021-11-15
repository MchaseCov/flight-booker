class BookingsController < ApplicationController
  before_action :set_booking_attributes, only: %i[new create]

  def new
    @booking = @flight_choice.bookings.new
    @passenger_count.times { @booking.passengers.build }
    booked_flight_attributes(@flight_choice)
  end

  def create
    @booking = @flight_choice.bookings.new(booking_params)
    if @booking.save
      redirect_to [@flight, @booking], notice: 'Your flight is booked! Here is the info. A reciept has (not) been emailed to you!'
    else
      render :new, alert: @booking.errors.full_messages
    end
  end

  def show
    @booking = Booking.find(params[:id])
    @passenger_count = @booking.passengers.count
    booked_flight_attributes(@booking.flight)
  end

  private

  def booking_params
    params.require(:booking).permit(passengers_attributes: %I[id name email])
  end

  def set_booking_attributes
    @flight_choice = Flight.find(params[:flight_id])
    @passenger_count = params[:tickets].present? ? params[:tickets].to_i : booking_params.to_h.length
  end

  def booked_flight_attributes(flight)
    @departure_airport = flight.departure_airport.code
    @arrival_airport = flight.arrival_airport.code
    @departure_time = flight.departure_time.strftime('on %m-%d-%Y, at %H:%M')
    @arrival_time = (flight.departure_time + flight.duration * 60 * 60)
                    .strftime('on %m-%d-%Y, at %H:%M')
  end
end
