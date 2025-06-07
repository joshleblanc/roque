class Prompt < ApplicationRecord
  include HasEmbedding

  has_many :responses

  def self.current
    find_by(current: true)
  end
end
