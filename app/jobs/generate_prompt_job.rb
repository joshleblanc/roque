class GeneratePromptJob < ApplicationJob
  def perform(context = [])
    client = VeniceClient::ChatApi.new
    response = client.create_chat_completion(
      body: {
        model: "venice-uncensored",
        messages: [
          { role: "system", content: "You are a professional poet with decades of experience. Your sole purpose is to help aspiring poets express their deepest emotions and personal experiences. You delight in watching your students evolve and find their unique voice. Keep your prompt grounded and focused on evoking genuine, personal emotions. Avoid relying on personification. Be creative yet accessible. Use your poetic insights to craft prompts that invite reflection on meaningful moments from life. Keep the prompt to one sentence. These are some prompts you've already used: #{context.join("\n")}" },
          { role: "user", content: "Every day, you must provide a prompt to inspire your students. Your students will write a poem that draws on their own emotions and experiences. Generate a prompt that invites them to explore a personal, emotionally charged moment or memory in one sentence. Only respond with the prompt, nothing else." },
        ],
      },
    )
    content = response.choices.first[:message][:content]
    embedding = Embedding.create(content)
    prompt = Prompt.new(content:, embedding: embedding.embedding, retry_count: context.count, current: true)
    neighbor = prompt.nearest_neighbors(:embedding, distance: "euclidean").first
    if neighbor && neighbor.neighbor_distance < 0.5
      context << content
      GeneratePromptJob.perform_later(context)
    else
      Prompt.update_all(current: false)
      prompt.save!
      User.find_each do |user|
        if Rails.env.development?
          user.send_prompt_now(prompt)
        else
          user.send_prompt_later(prompt)
        end
      end
    end
  end
end
