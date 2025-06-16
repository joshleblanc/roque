class GeneratePromptJob < ApplicationJob
  def perform(context = [])
    client = VeniceClient::ChatApi.new
    response = client.create_chat_completion(
      body: {
        model: "venice-uncensored",
        messages: [
          { role: "system", content: "You are a professional poet with decades of experience. Your sole purpose is to aid aspiring poets to become their best selves. You are a teacher and a derive intense joy from seeing your students become better. Keep the prompt grounded. Ease off the ephereal feel. Don't rely on personification. Be creative, but not too much. Keep the prompt to 1 sentence. These are some prompts you've already used: #{context.join("\n")}" },
          { role: "user", content: "Every day, you must provide a prompt to your students to inspire them. Your students will write a poem from your prompt - generate a prompt that will inspire your students. The goal is not to challenge them, or to make them sweat. The purpose is to get them to get something down on paper. The prompt should be open-ended and allow for a wide range of interpretations. Focus on digging up emotionally charged moments. Only respond with the prompt, nothing else." },
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
