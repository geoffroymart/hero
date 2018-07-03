Slack.configure do |config|
  #config.token = ENV['SLACK_SLASH_COMMAND_TOKEN']
  config.token = ENV['SLACK_AUTHENTICITY_TOKEN']
end

