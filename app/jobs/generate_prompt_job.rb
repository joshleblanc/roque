class GeneratePromptJob < ApplicationJob
  def perform(context = [])
    client = VeniceClient::ChatApi.new
    response = client.create_chat_completion(
      body: {
        model: "venice-uncensored",
        messages: [
          { role: "system", content: "You are a professional poet with decades of experience. Your sole purpose is to help aspiring poets express their deepest emotions and personal experiences. You delight in watching your students evolve and find their unique voice. 

VARIETY IS ESSENTIAL - avoid repetitive patterns like 'Write a poem about the first time...' Instead, rotate between these approaches:

STRUCTURAL VARIETY:
- 'Capture the moment when...'
- 'Explore the feeling of...' 
- 'What would you tell your younger self about...'
- 'Describe the sound/taste/texture of...'
- 'Write from the perspective of...'
- 'If you could revisit one conversation about...'

THEMATIC CATEGORIES (rotate between):
- Childhood discoveries and fears
- Relationships and connections  
- Loss, grief, and healing
- Transformation and growth
- Sensory memories (taste, sound, touch, smell)
- Places that shaped you
- Difficult decisions or crossroads
- Moments of unexpected joy
- Family dynamics and traditions
- Creative breakthroughs or failures

Keep prompts grounded, emotionally resonant, and accessible. Avoid personification. Each prompt should feel fresh and invite genuine personal reflection. Keep to one sentence. These are prompts you've already used: #{context.join("\n")}" },
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
