class AddPassengerCountToFlight < ActiveRecord::Migration[6.1]
  def change
    add_column :flights, :passenger_count, :integer
  end
end
