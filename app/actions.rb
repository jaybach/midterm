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
  @question = Question.new
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

# post '/tests/:id/edit' do
#   @test = Test.find_by(id: params[:id])
  


post '/questions' do
  @question = Question.new(
    user_id:  @auth_user.id,
    content: params[:content],
    image: params[:image_url]
  )
  if @question.save
    all_answers = []
    all_answers << [params[:answer1_content], params[:answer1_correct]] unless params[:answer1_content] == ""
    all_answers << [params[:answer2_content], params[:answer2_correct]] unless params[:answer2_content] == ""
    all_answers << [params[:answer3_content], params[:answer3_correct]] unless params[:answer3_content] == ""
    all_answers << [params[:answer4_content], params[:answer4_correct]] unless params[:answer4_content] == ""
    all_answers << [params[:answer5_content], params[:answer5_correct]] unless params[:answer5_content] == ""
    all_answers.each do |answer|
    if answer[0] != ""
      Answer.create(
        content: answer[0],
        correct: answer[1],
        question_id:@question.id
        )
    end
  end
    redirect '/questions'
  else
    erb :'question/new'
  end
end

# List A Question

get '/questions/:id' do
  @question = Question.find(params[:id])
  @user = User.find(@question.user_id)
  @title = "#{@question.content} created by #{@user.name}"
  @other_questions_from_this_user = Question.where(user_id: @user.id).where.not(id: params[:id])
  erb :'questions/show'
end

# Delete A Question

get '/questions/delete/:id' do
  Question.find(params[:id]).destroy
  redirect :'questions'
end

# List All Questions

get '/questions' do
  @title = 'See all questions in our library'
  @all_questions = Question.all.order(created_at: :desc)
  erb :'questions/index'
end

