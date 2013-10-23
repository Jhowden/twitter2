get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # at this point in the code is where you'll need to create your user account and store the access token
  @user = User.find_or_create_by_username(username: @access_token.params[:screen_name], 
    oauth_token: @access_token.params[:oauth_token],
    oauth_secret: @access_token.params[:oauth_token_secret] )
  
  session[:user_id] = @user.id

  erb :index
  
end

get '/status' do
 @tweetid = Tweet.last.id
 @sidekiq_id = TweetWorker.perform_async(@tweetid)

 if request.xhr?
  content_type :json
  {job_id: @sidekiq_id}.to_json
end
redirect to "/status/#{@sidekiq_id}"
end

get '/status/:job_id' do
  @jid = params[:job_id]
  if job_is_complete?(params[:job_id])
    erb :complete, layout: false
  # else
  #   erb :fail, layout: false
  end

end


post '/tweet' do

  @user = User.find(session[:user_id])

  @user.tweet(params[:jonsdecision])
  
  # tweet_worker = TweetWorker.new

  # tweet_worker.perform(Tweet.last.id)

  # Twitter.update(params[:jonsdecision])

end
