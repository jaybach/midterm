# Helpers
helpers do
  def current_user
    @auth_user = User.find(session[:user_id]) if session[:user_id]
  end
end

before do
  current_user
end

# Homepage (Root path)
get '/' do
  @title = 'Crowd-sourced test builders'
  erb :index
end

get '/users/new' do
  @title = 'Create a new user'
  erb :'users/new'
end

post '/users' do
  @new_user = User.new(
    username: params[:username],
    name:  params[:name],
    email: params[:email],
    company: params[:company],
    password: params[:password]
  )
  if params[:password] == params[:password_confirmation]
    if @new_user.save
      session[:user_id] = @new_user.id
      redirect '/'
    else
      erb :'users/new'
    end
  else
    @error = 'Passwords don\'t match! Please try again!'
    erb :'users/new'
  end
end

get '/login' do
  @title = 'Log into your account'
  erb :'users/login'
end

post '/login' do
  @unauth_user = User.find_by_username(params[:username])
  if @unauth_user
    if @unauth_user.password == params[:password]
      session[:user_id] = @unauth_user.id
      redirect '/'
    else
      @error = 'Incorrect password!'
      erb :'users/login'
    end
  else
    @error = 'Username doesn\'t exist!'
    erb :'users/login'
  end
end

get '/logout' do
  session.clear
  redirect :'/'
end

