# This file contains all record creation needed to seed the database with Flight records.
# Each flight consists of:
# ID
# Departure_Airport_ID: ID of the associated Airport the Flight departs from
# Arrival_Airport_ID: ID of the associated Airport the Flight arrives at
# Departure_Time: The Datetime that the Flight will depart.)
# Duration: Time in Hours that the flight will take.
# Timestamps

require 'active_support/core_ext/integer/time'

25.times do
  Flight.create(
    departure_airport_id: rand(1..31),
    arrival_airport_id: rand(1..31),
    departure_time: rand(2.months).seconds.from_now.to_s,
    duration: rand(1..7)
  )
end
