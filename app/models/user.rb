require_relative '../helpers/oauth'

class User < ActiveRecord::Base
  has_many :tweets
  
  def tweet(status)
    tweet = Tweet.create!(status: status, user_id: self.id)
    # time=time.minute
    TweetWorker.perform_async(tweet.id)

    # if job_is_complete?(jid)
    #   puts "_____________"
    #   Twitter.update(tweet.status)
    #   puts "_____________"
    # end
  end
end
