# encoding: utf-8
require 'bundler'
Bundler.require(:default)

helpers SocNetworkCred::Facebook, SocNetworkCred::Twitter

get "/" do
  if facebook_access_token
    @news_feeds = facebook_news_feed
  end
  @news_feeds = [{"message" => ""}] unless @news_feeds
  @twitter_timeline = twitter_timeline
  haml :main
end
