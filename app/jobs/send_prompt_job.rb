class SendPromptJob < ApplicationJob
  queue_as :default

  def perform(user, prompt)
    discord = user.connected_services.find_by(provider: "discord")
    return unless discord

    Bot.instance.send_dm(discord.uid, prompt.content)
    user.update!(last_sent_prompt: prompt)
  end
end
