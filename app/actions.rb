# Helpers
helpers do
  def current_user
    @auth_user = User.find(session[:user_id]) if session[:user_id]
  end

  def auth_user(user)
    session[:user_id] = user.id
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
    user_name: params[:user_name],
    name:  params[:name],
    email: params[:email],
    company: params[:company],
    password: params[:password]
  )
  if params[:password] == params[:password_confirmation]
    if @new_user.save
      auth_user(@new_user)
      redirect '/'
    else
      erb :'users/new'
    end
  else
    @error = "Passwords don't match! Please try again!"
    erb :'users/new'
  end
end

get '/login' do
  @title = 'Log into your account'
  erb :'users/login'
end

post '/login' do
  @unauth_user = User.find_by(user_name: params[:user_name])
  if @unauth_user && @unauth_user.password == params[:password]
    auth_user(@unauth_user)
    redirect '/'
  else
    @error = 'Invalid credentials'
    erb :'users/login'
  end
end

get '/logout' do
  session.clear
  redirect '/'
end

