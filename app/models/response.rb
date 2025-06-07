class Response < ApplicationRecord
  include HasEmbedding

  belongs_to :prompt
end
