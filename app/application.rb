require 'sinatra/base'

module SeniorProject
	class Application < Sinatra::Base
    set :views, Proc.new { File.join(root, "views") }
    set :sessions, true
    
		get '/' do
      @page_title = "Nearby Instagram stream"
      
      @session_id = session[:id]
      
      erb :stream
		end

	end
end