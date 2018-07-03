require 'unicode/emoji'

class RequestsController < ApplicationController
  before_action :set_request, except: [:index, :history, :new, :create]
  skip_before_action :authenticate_user!, except: [:index, :history, :show, :done, :decline]

  def index
    if params[:query].present?
      sql_query = 'title ILIKE :query OR email ILIKE :query OR description ILIKE :query'
      @requests = policy_scope(Request).where(sql_query, query: "%#{params[:query]}%").order(created_at: :desc).where(status: 'pending', disable: false)
    else
      @requests = policy_scope(Request).where(status: 'pending', disable: false).order(created_at: :desc)
    end
  end

  def history
    if params[:query].present?
      sql_query = 'title ILIKE :query OR email ILIKE :query OR description ILIKE :query'
      @requests = policy_scope(Request).where(sql_query, query: "%#{params[:query]}%").order(created_at: :desc).where.not(status:'pending', disable: true)
    else
      @requests = policy_scope(Request).where.not(status: 'pending', disable: true).order(created_at: :desc)
    end
    authorize @requests
  end

  def show
    authorize @request
    @request.request_read.mark_as_read! for: current_user
    @attachments = @request.attachments.all
    members = SlackUsersService.new.call
    @member = members.find { |member| member.id == @request.slack_user_id }
  end

  def new
    @request = Request.new
    @attachment = @request.attachments.build
    @members = SlackUsersService.new.call
    # @members calls the Slack API & stores the users_list in json
    # it is then used in the new request form to get a dropdown menu of slack users
    authorize @request
  end

  def create
    @request = Request.new(request_params)
    authorize @request
    @request.email = current_user.email if current_user
    if @request.slack_user_id
      members = SlackUsersService.new.call
      @member = members.find { |member| member.id == @request.slack_user_id }
      @request.slack_avatar = @member.profile.image_original
      @request.save
    end

    if @request.save
      if params[:attachments]
        params[:attachments]['photo'].each do |ph|
          a = Attachment.create(photo: ph, request_id: @request.id)
          a.request!
        end
      end
      if current_user
        if @request.slack_user_id
        members = SlackUsersService.new.call
        @member = members.find { |member| member.id == @request.slack_user_id }
        client = Slack::Web::Client.new
        client.chat_postMessage(
          channel: "#{@member.id}",
          text: "Hi #{@member.real_name}! Your request: '#{@request.title}' has been created by your Hero! Keep up the good work #{Unicode::Emoji.list("Travel & Places", "transport-air")[10]}",
          as_user: true
          )
        end
        redirect_to requests_path
      else
        # send email notification to team member
        UserMailer.send_new_request_email_to_tm(@request).deliver_now
        # send email notification to office manager
        UserMailer.send_new_request_email_to_om(@request, User.last).deliver_now
        redirect_to confirmation_request_path(@request)
      end
    else
      render :new
    end
  end

  def confirmation
    authorize @request
  end

  def edit
    authorize @request
  end

  def update
    authorize @request
    @request.update(request_params)
    if current_user
      members = SlackUsersService.new.call
      @member = members.find { |member| member.id == @request.slack_user_id }
      redirect_to requests_path
    else
      redirect_to confirmation_request_path(@request)
    end
  end

  def cancel
    authorize @request
  end

  def disable
    authorize @request
    @request.update(disable: true)
    redirect_to cancel_request_path
  end

  def done
    authorize @request
    @request.update(status: 'done', end_comment: params[:request][:end_comment])
    if @request.slack_user_id
      members = SlackUsersService.new.call
      @member = members.find { |member| member.id == @request.slack_user_id }
      client = Slack::Web::Client.new
      client.chat_postMessage(
        channel: "#{@member.id}",
        text: "Hi #{@member.real_name}! Your request: '#{@request.title}' has been done by your Hero#{Unicode::Emoji.list("Smileys & People", "body")[6]} #{('Your hero left this message: ' + @request.end_comment) if @request.end_comment}",
        as_user: true
        )
      redirect_to requests_path
    else
      UserMailer.send_terminated_email_to_tm(@request, @request.status, @request.end_comment).deliver_now
      redirect_to requests_path
    end
  end

  def decline
    authorize @request
    @request.update(status: 'declined', end_comment: params[:request][:end_comment])
    if @request.slack_user_id
      members = SlackUsersService.new.call
      @member = members.find { |member| member.id == @request.slack_user_id }
      client = Slack::Web::Client.new
      client.chat_postMessage(
        channel: "#{@member.id}",
        text: "Hi #{@member.real_name}! Your request: '#{@request.title}' has been declined by your Hero…#{Unicode::Emoji.list("Smileys & People", "face-neutral")[0]} #{('Your hero left this message: ' + @request.end_comment) if @request.end_comment} - Feel free to chat about it!",
        as_user: true
        )
      redirect_to requests_path
    else
      UserMailer.send_terminated_email_to_tm(@request, @request.status, @request.end_comment).deliver_now
      redirect_to requests_path
    end
  end

  def personal_note
    authorize @request
    @request.update(request_params)
    if params[:attachments]
      params[:attachments]['photo'].each do |ph|
        a = Attachment.create(photo: ph, request_id: @request.id)
        a.personal!
      end
    end
    redirect_to request_path(@request)
  end


  private

  def request_params
    params.require(:request).permit(:email, :title, :description, :slack_avatar, :slack_user_id, :status, :end_comment, :personal_note, attachments_attributes: [:id, :request_id, :photo, :attachment_type])
  end

  def set_request
    @request = Request.find(params[:id])
  end
end
