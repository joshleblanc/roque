class ProfilesController < ApplicationController
  include TimeZone

  before_action :require_authentication

  def edit
    @user = Current.user
    @timezones = ActiveSupport::TimeZone.all.map(&:name)
  end

  def update
    @user = Current.user
    if @user.update(profile_params)
      redirect_to edit_profile_path, notice: "Profile updated!"
    else
      @timezones = ActiveSupport::TimeZone.all.map(&:name)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:time_zone, :notification_hour, :notification_minute)
  end
end
