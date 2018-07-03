class MyDevise::RegistrationsController < Devise::RegistrationsController

  def update
    super
    if resource.save
      resource.update(my_devise_params)
    else
      return render :edit
    end
  end

  private

  def my_devise_params
    params.require(:user).permit(profile_attributes: [:first_name, :last_name, :avatar])
  end
end
