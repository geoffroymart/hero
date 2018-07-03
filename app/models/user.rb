class User < ApplicationRecord
  acts_as_reader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:slack]

  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  after_create :send_welcome_email

  # Optional: Allow a subset of users as readers only
  # def self.reader_scope
  #  where(is_admin: true)
  # end
  def profile
    super || Profile.create(user: self)
  end

  def self.find_for_slack_oauth(auth)

    slack_members = SlackUsersService.new.call
    slack_user = slack_members.find { |member| member.id == auth.uid }
    user_params = {}
    # user_params.merge! auth.info.slice(:email, :team_id)
    user_params[:slack_user_id] = auth.uid
    user_params[:email] = slack_user.profile.email
    user_params[:slack_team_id] = slack_user.team_id

    user_params = user_params.to_h

    user = User.find_by(slack_user_id: auth.uid)

    user ||= User.find_by(email: slack_user.profile.email) # User did a regular sign up in the past.
    if user
      user.profile.avatar = slack_user.profile.image_original if slack_user.profile.image_original != nil
      user.update(user_params)
    else
      user = User.new(user_params)
      user.profile.avatar = slack_user.profile.image_original if slack_user.profile.image_original != nil
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end

    return user
  end


  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end
end
