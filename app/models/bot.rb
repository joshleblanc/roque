class Bot
  include Singleton

  attr_reader :bot

  def initialize
    @bot = Discordrb::Bot.new(
      token: Rails.application.credentials.dig(:discord, :token),
    )

    @bot.message do |event|
      connected_service = ConnectedService.find_by(uid: event.user.id)
      return unless connected_service

      Response.create!(prompt: Prompt.current, discord_uid: event.user.id, content: event.message.content)
    end
  end

  def run
    @bot.run
  end

  def send_dm(uid, content)
    channel = @bot.pm_channel(uid)
    channel.send_message(content)
  end
end
