class Embedding
  attr_reader :embedding

  def initialize(embedding)
    @embedding = embedding
  end

  def self.create(input)
    new(GenerateEmbeddingJob.perform_now(input))
  end

  def to_s = embedding.to_s
end
