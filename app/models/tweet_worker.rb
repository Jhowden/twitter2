require 'redis'
require 'sidekiq'

require_relative '../helpers/oauth'


class TweetWorker
  include Sidekiq::Worker

  def perform(tweet_id)
    tweet = Tweet.find(tweet_id)

    user = User.find_by_username(tweet.user.username)

    client = Twitter.configure do |config|
      config.oauth_token = user.oauth_token
      config.oauth_token_secret = user.oauth_secret
    end

    client.update(tweet.status)
  end

end

   # set up Twitter OAuth client here
    # actually make API call
    # Note: this does not have access to controller/view helpers
    # You'll have to re-initialize everything inside here
