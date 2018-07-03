require 'rest-client'
require 'json'

class SlackUsersService

  def call
    url = "https://slack.com/api/users.list?token=#{ENV['SLACK_AUTHENTICITY_TOKEN']}&pretty=1"
    response = RestClient.get(url)
    return JSON.parse(response, object_class: OpenStruct).members.select { |member| member.real_name != nil }
  end

  #the method returns an array of members objects (gotten from the Slack API)
end

