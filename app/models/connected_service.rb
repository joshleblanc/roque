class ConnectedService < ApplicationRecord
  belongs_to :user

  has_many :responses, foreign_key: :discord_uid, primary_key: :uid
end
