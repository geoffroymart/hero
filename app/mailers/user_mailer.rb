class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Hero App!')
  end

  def send_new_request_email_to_tm(request)
    @request = request
    mail(to: @request.email, subject: 'Your request has been sent')
  end

  def send_new_request_email_to_om(request, user)
    @user = user
    @request = request
    mail(to: @user.email, subject: 'A new request has been created')
  end

  def send_terminated_email_to_tm(request, status, comment)
    @request = request
    mail(to: @request.email, subject: "Your request has been #{status}")
  end
end
