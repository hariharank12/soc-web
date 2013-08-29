module SocNetworkCred
   
  module Facebook

    def self.app_id
      @facebook_credential["app_id"]
    end

    def self.app_secret
      @facebook_credential["app_secret"]
    end

    def self.set_credential cred
      @facebook_credential = cred
    end

    def facebook_access_token
      session['access_token']
    end

    def graph_obj
      session['facebook_graph']
    end

    def facebook_news_feed
      graph_obj.fql_query("SELECT post_id, app_id, source_id, updated_time, filter_key, attribution, message, action_links, likes, permalink FROM stream WHERE filter_key IN (SELECT filter_key FROM stream_filter WHERE uid = me() AND type = 'newsfeed')")
    end

  end

  module Twitter

    def self.consumer_key
      @twitter_credential["consumer_key"]
    end

    def self.consumer_secret
      @twitter_credential["consumer_secret"]
    end

    def self.oauth_token
      @twitter_credential["oauth_token"]
    end

    def self.oauth_token_secret
      @twitter_credential["oauth_token_secret"]
    end

    def self.set_credential cred
      @twitter_credential = cred
    end

    def twitter_access_token(consumer_key, consumer_secret, oauth_token, oauth_token_secret)
      consumer = OAuth::Consumer.new(consumer_key, consumer_secret, { :site => "http://api.twitter.com", :scheme => :header })
      # now create the access token object from passed values
      token_hash = { :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret }
      OAuth::AccessToken.from_hash(consumer, token_hash)
    end

    def twitter_timeline
      access_token = twitter_access_token(SocNetworkCred::Twitter.consumer_key, SocNetworkCred::Twitter.consumer_secret, SocNetworkCred::Twitter.oauth_token, SocNetworkCred::Twitter.oauth_token_secret)
      response = access_token.request(:get, "https://api.twitter.com/1.1/statuses/home_timeline.json")
      JSON.parse(response.body)
    end

  end

end
