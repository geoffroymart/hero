class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def slack
    user = User.find_for_slack_oauth(request.env['omniauth.auth'])

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Slack') if is_navigational_format?
    else
      session['devise.slack_data'] = request.env['omniauth.auth']
      redirect_to requests_path
    end
  end
end
