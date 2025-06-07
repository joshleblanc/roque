class Bot
  include Singleton

  attr_reader :bot

  def initialize
    @bot = Discordrb::Bot.new(
      token: Rails.application.credentials.dig(:discord, :token),
    )

    @bot.message do |event|
      puts event.content
    end
  end

  def run
    @bot.run
  end
end
