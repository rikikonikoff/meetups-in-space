require 'sinatra'
require_relative 'config/application'

set :bind, '0.0.0.0'  # bind to all interfaces

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end


get '/' do
  redirect '/meetups'
end

get '/meetups' do
  erb :'meetups/index'
end

get '/meetups/new' do
  erb :'meetups/new'
end

post '/meetups/new' do
  @name = params[:name]
  @location_name = params[:location_name]
  @address = params[:address]
  @description = params[:description]

  @this_location = Location.where({ name: @location_name, address: @address})

  if @name == ''
    @error = 'Please enter a name for your meetup'
    erb :'meetups/new'
  elsif @location_name == ''
    @error = 'Please enter the name of your meetup\'s location'
    erb :'meetups/new'
  elsif @description == ''
    @error = 'Please enter a descripton of your meetup'
    erb :'meetups/new'
  elsif current_user == nil
    @error = 'You must sign in before creating an event'
    erb :'meetups/new'
  else
    if @this_location.empty?
      @location = Location.create({ name: @location_name, address: @address })
    else
      @location = @this_location[0]
    end

    @meetup = Meetup.create({ name: @name, creator: current_user, description: @description, location: @location })

    if !@meetup.valid?
      @error = 'Invalid Meetup. Try something more unique!'
      erb :'meetups/new'
    else
      Commitment.create({ meetup: @meetup, user: @meetup.creator })

      @success = 'Meetup created successfully!'
      erb :'meetups/show'
    end
  end
end

get '/meetups/:meetup_id' do
  @meetup_id = params[:meetup_id]
  @meetup = Meetup.find_by(id: @meetup_id)

  erb :'meetups/show'
end

post '/meetups/:meetup_id' do
  @meetup_id = params[:meetup_id]
  @meetup = Meetup.find(@meetup_id)
  @path = '/meetups/' + @meetup_id.to_s

  if current_user == nil
    @error = 'You must sign in to add your name to the list'
    erb :'meetups/show'
  else
    @commitment = Commitment.create({ user: current_user, meetup: @meetup })
    redirect @path
  end
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end
