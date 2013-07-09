get '/' do
  if @user = params[:twitter_username]
    redirect "/#{@user}"
  else
    erb :index
  end
end

get '/:username' do
  @user = User.find_or_create_by_username(params[:username])
  if @user.tweets.empty?
    user_tweets = Twitter.user_timeline(@user.username)
    user_tweets.each do |tweet|
      new_tweets = Tweet.create(tweet: tweet.text, user_id: @user.id)
      @user.tweets << new_tweets
    end
    erb :view_tweets
    # User#fetch_tweets! should make an API call
    # and populate the tweets table
    #
    # Future requests should read from the tweets table
    # instead of making an API call
    # @user.fetch_tweets!
  else
    if @user.tweets_stale?
      @user.fetch_tweets!
      erb :view_tweets
    else
      @user.tweets
      erb :view_existing_tweets
    # grab last tweet from twitter api
    # pop off last tweet from stored tweets arrray
    # if theyre the same
    #   return the tweets in the database
    # else
    #   scrap the twitter api for last ten tweets and save to db
    #   display new tweet data
    end

  end
  # @tweets = @user.tweets.limit(10)
end



# @saved_user = User.find_or_create_by_username(user)
#   if @saved_user
#     @all = []
#     me = Twitter.user_timeline(@saved_user)
#     me.each do |tweet|
#       @all << tweet.text
#     end
#     @all
#   else
#   end

#   erb :view_tweets
