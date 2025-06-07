class AddTimezoneAndNotificationTimeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :time_zone, :string
    add_column :users, :notification_hour, :integer, default: 6
    add_column :users, :notification_minute, :integer, default: 0
  end
end
