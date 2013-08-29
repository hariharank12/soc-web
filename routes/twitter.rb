require 'bundler'
Bundler.require(:default)

helpers SocNetworkCred::Twitter

get '/twitter' do
  @twitter_timeline = twitter_timeline
  haml :twitter
end
