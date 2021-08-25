class User < ApplicationRecord
  after_create_commit :user_slack_notification
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def user_slack_notification
    SlackNotifier::USER_SLACK.ping("🎉 New user\nId: #{self.id}\nUsername: #{self.spotify_display_name}. See at #{self.spotify_url}")
  end

end
