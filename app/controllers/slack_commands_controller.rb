# think to change the URL from ngrok to our name domain in production
#                                    or to your own ngrok URL

class SlackCommandsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  skip_after_action :verify_authorized


  def hero
    @request = Request.new(title: command_params.to_h[:text], slack_user_id: params[:user_id])
    members = SlackUsersService.new.call
    @member = members.find { |member| member.id == @request.slack_user_id }
    @request.slack_avatar = @member.profile.image_original
    if @request.save
      render json: {
        response_type: "in_channel",
        text: "Your request has been sent to your Hero!",
        attachments: [
          {
            text: "You can see/update/add a file to it here: https://hero--app.herokuapp.com#{confirmation_request_path(@request)}"
          }
        ]
      },
        status: :created
    else
      render json: {
        response_type: "in_channel",
        text: "A problem has occured… Please try again",
      },
      status: :not_found
    end
  end

  def my_requests
    @requests = Request.where(status:"pending", disable: false, slack_user_id: params[:user_id]).order(created_at: :desc)
    attachments = []
    @requests.each do|request|
      attachments <<  { text: " #{request.title} : https://hero--app.herokuapp.com#{confirmation_request_path(request)}",

                        color: "#8587dc",
                        }
    end
    render json: {
      response_type: "in_channel",
      text: "Your pending request(s):",
      attachments: attachments
    }
end


  private

  def valid_slack_token?
    params[:token] == ENV["SLACK_SLASH_COMMAND_TOKEN"]
  end

  # Only allow a trusted parameter "white list" through.
  def command_params
    params.permit(:text, :token, :user_id, :response_url)
  end
end
