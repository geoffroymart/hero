class ProfilesController < ApplicationController
  before_action :set_profile, only: [:update, :edit]

  def edit
  end

  def update
    @profile.update(profile_params)
    redirect_to requests_path
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :avatar)
  end

  def set_profile
    @profile = Profile.find(params[:id])
  end
end
