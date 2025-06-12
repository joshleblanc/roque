class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :connected_services, dependent: :destroy
  has_many :responses, through: :connected_services

  belongs_to :last_sent_prompt, class_name: "Prompt"

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def send_prompt_now(prompt)
    SendPromptJob.perform_now(self, prompt)
  end

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
