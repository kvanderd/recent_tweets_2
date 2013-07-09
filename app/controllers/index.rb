get '/' do
  if @user = params[:twitter_username]
    redirect "/#{@user}"
  else
    erb :index
  end
end

get '/:username' do

  @user = User.find_or_create_by_username(params[:username])
  p @user

  if @user.tweets.empty?

    user_tweets = Twitter.user_timeline(@user.username)

    @recent_tweets = []

    user_tweets.each do |tweet|
      @recent_tweets << tweet.text
    end

    p @recent_tweets

    new_tweets = Tweet.create(tweet: @recent_tweets, user_id: @user.id)
    p new_tweets
    @user.tweets << new_tweets
    # User#fetch_tweets! should make an API call
    # and populate the tweets table
    #
    # Future requests should read from the tweets table
    # instead of making an API call
    # @user.fetch_tweets!
    erb :view_tweets
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
