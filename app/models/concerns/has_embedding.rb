module HasEmbedding
  extend ActiveSupport::Concern

  included do
    has_neighbors :embedding, dimensions: 1024
  end

  def create_embedding!
    update(embedding: Embedding.create(content).embedding)
  end
end
