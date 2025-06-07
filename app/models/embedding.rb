class Embedding
  attr_reader :embedding

  def initialize(embedding)
    @embedding = embedding
  end

  def self.create(input)
    model = Informers.pipeline("embedding", "BAAI/bge-base-en-v1.5")
    embedding = model.(input)
    new(embedding)
  end

  def to_s = embedding.to_s
end
