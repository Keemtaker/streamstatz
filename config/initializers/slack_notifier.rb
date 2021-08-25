module SlackNotifier
  USER_SLACK = Slack::Notifier.new ENV['USER_SLACK_WEBHOOK']
end
