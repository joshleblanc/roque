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

      user = connected_service.user
      Response.create!(prompt: user.last_sent_prompt, discord_uid: event.user.id, content: event.message.content, message_id: event.message.id)
    end

    @bot.message_edit do |event|
      connected_service = ConnectedService.find_by(uid: event.user.id)
      return unless connected_service

      response = Response.find_by(message_id: event.message.id)
      return unless response

      response.update(content: event.message.content)
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
