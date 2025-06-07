json.extract! response, :id, :prompt_id, :discord_uid, :created_at, :updated_at
json.url response_url(response, format: :json)
