class PassengerMailer < ApplicationMailer
  default from: 'sales@flightfinder.com'

  def booking_confirmation_email(passenger, booking, flight)
    @url = booking_url(booking)
    @passenger = passenger
    @flight = flight
    mail(to: @passenger.email, subject: 'Thank you for booking with FlightFinder!')
  end
end
