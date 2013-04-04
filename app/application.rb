require 'sinatra/base'
require 'instagram'
require 'pusher'

module SeniorProject
	class Application < Sinatra::Base
    set :views, Proc.new { File.join(root, "views") }
    set :sessions, true
    set :session_secret, 'W9yAGZ4wffSXfCmjUR'
    
    # TODO: Insert API info
    Instagram.configure do |config|
      config.client_id = "5c7f36fcb0d84a7da3193094da8556fd"
      config.client_secret = "d6c5e05ef5a642efb4c4177b0e2ba8fe"
    end
    
    # TODO: Insert API info
    Pusher.app_id = "40747"
    Pusher.key = "6754b6ae8be0fa776c7b"
    Pusher.secret = "9f53de97ca2d1b1cf398"
    
    DEFAULT_RADIUS = 80467 # approx. 50 miles
    
		get '/' do
      @page_title = "Local Instagram Photos"
      
      # Set a session id if there isn't one already set
      session[:id] = ('a'..'z').to_a.shuffle[0,5].join if session[:id].nil?
      @session_id = session[:id]
      
      @longitude = nil#session[:longitude]
      @latitude = nil#session[:latitude]

      @photos = []#Instagram.media_popular
      
      erb :stream
		end
    
    post '/subscribe' do
      # Subscribe to a location for the specified session
      # Params: longitude, latitude

      # Get parameters from request and session
      latitude = params[:latitude]
      longitude = params[:longitude]
      session_id = session[:id]

      # Save location to session
      session[:latitude] = latitude
      session[:longitude] = longitude      

      # TODO: Check for a subscription already active for this session ID
      
      # Build options to use for subscription
      subscription_options = {
        :lat => latitude,
        :lng => longitude,
        :radius => DEFAULT_RADIUS
      }
      # TODO: Finish this
      #Instagram.create_subscription("geography", "http://justin.hathaway.cc/instagram/receive/#{session_id}", "media", subscription_options)

      content_type 'application/json', :charset => 'utf-8'
      photos = Instagram.media_search(latitude, longitude, :distance => 5000)      
      photos.to_json
    end
    
    post '/instagram/receive/:session_id' do
      # Receive notifications from Instagram API, send information to Pusher
      # Params: ???
      session_id = params[:session_id]
      
      # TODO: Finish this
      # Send new photo info to client
      #Pusher.trigger(session_id, 'new_photo', {:some => "data"})
    end
	end
end