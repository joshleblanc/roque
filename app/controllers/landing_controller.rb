class LandingController < ApplicationController
  allow_unauthenticated_access only: :index

  def index
    @recent_prompts = Prompt.order(created_at: :desc).limit(10)
  end
end
