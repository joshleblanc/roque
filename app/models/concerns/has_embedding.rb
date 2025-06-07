module HasEmbedding
  extend ActiveSupport::Concern

  included do
    has_neighbors :embedding, dimensions: 768
  end

  def create_embedding!
    update(embedding: Embedding.create(content).embedding)
  end
end
