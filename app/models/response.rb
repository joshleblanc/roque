class Response < ApplicationRecord
  include HasEmbedding

  belongs_to :prompt
  belongs_to :connected_service, primary_key: :uid, foreign_key: :discord_uid
  has_one :user, through: :connected_service
end
