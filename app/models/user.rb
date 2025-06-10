class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :connected_services, dependent: :destroy
  has_many :responses, through: :connected_services

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def send_prompt_later(prompt)
    Time.use_zone(time_zone) do
      target = Time.current.change(hour: notification_hour, min: notification_minute)
      if target <= Time.current
        target += 1.day
      end
      SendPromptJob.set(wait_until: target).perform_later(self, prompt)
    end
  end
end
