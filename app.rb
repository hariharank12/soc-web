# encoding: utf-8
require 'sinatra'
require 'sinatra/config_file'
require 'haml'

require_relative 'minify_resources'
require_relative 'helpers/init'
require_relative 'models/init'
require_relative 'routes/init'

enable :sessions

use Rack::Session::Cookie, secret: 'hare!yoursecret'

configure :production do
  set :haml, { :ugly=>true }
  set :clean_trace, true
  set :css_files, :blob
  set :js_files,  :blob
  MinifyResources.minify_all
end

configure :development do
  set :css_files, MinifyResources::CSS_FILES
  set :js_files,  MinifyResources::JS_FILES
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

register Sinatra::ConfigFile
config_file 'config/credentials.yml'

SocNetworkCred::Facebook.set_credential settings.facebook
SocNetworkCred::Twitter.set_credential settings.twitter
