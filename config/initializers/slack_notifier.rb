module SlackNotifier
  USER_SLACK = Slack::Notifier.new ENV['USER_SLACK_WEBHOOK']
  PLAYLIST_SLACK = Slack::Notifier.new ENV['PLAYLIST_SLACK_WEBHOOK']
end
