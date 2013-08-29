# encoding: utf-8
require 'bundler'
Bundler.require(:default)

helpers SocNetworkCred::Facebook

get '/facebook' do
  if facebook_access_token
    @news_feeds = facebook_news_feed
    haml :facebook
  else
    '<a href="/facebook/login">Login</a>'
  end
end

get '/facebook/login' do
  # generate a new oauth object with your app data and your callback url
  session['oauth'] = Koala::Facebook::OAuth.new(SocNetworkCred::Facebook.app_id, SocNetworkCred::Facebook.app_secret, "#{request.base_url}/facebook/callback")
  # redirect to facebook to get your code
  redirect session['oauth'].url_for_oauth_code(:permissions => ["read_stream","publish_stream"])
end

get '/facebook/logout' do
  session['oauth'] = nil
  session['access_token'] = nil
  redirect '/facebook'
end

#method to handle the redirect from facebook back to you
get '/facebook/callback' do
  #get the access token from facebook with your code
  session['access_token'] = session['oauth'].get_access_token(params[:code])
  session['facebook_graph'] = Koala::Facebook::API.new(facebook_access_token)
  redirect '/facebook'
end
