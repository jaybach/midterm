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

# Register Page

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

# Login Page

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

# Logout

get '/logout' do
  session.clear
  redirect '/'
end

# My Account Page

get '/users/show' do
  @title = "#{@auth_user.name}'s account"
  erb :'users/show'
end

# Add New Question

get '/questions/new' do
  @title = 'Add a question to the library'
  erb :'questions/new'
end

get '/tests/new' do
  @title = 'Here are your tests, or create a new one!'
  @tests = Test.where(user_id: session[:user_id])
  erb :'tests/new'
end

get '/tests/:id' do
  @test = Test.find_by(id: params[:id])
  @questions = Question.all
  erb :'tests/show'
end

post '/tests' do
  @user = User.find(session[:user_id])
  @new_test= Test.new(
    name: params[:name],
    user_id: @user.id,
    logo: nil
    )
  if @new_test.save
    redirect '/tests/new'
  else
    erb :'tests/new'
  end
end

post '/questions' do
  @new_question = Question.new(
    question_content: params[:question_content],
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
    erb :'questions/show'
  end
end

