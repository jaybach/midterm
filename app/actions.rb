# Helpers
helpers do
  def current_user
    @auth_user = User.find(session[:user_id]) if session[:user_id]
  end

  def auth_user(user)
    session[:user_id] = user.id
  end

  def tagged_questions(id)
    tag = Tag.find(id)
    tagged_questions = []
    QuestionTag.where(tag_id: tag.id).each do |qt_combination|
      tagged_questions << Question.find(qt_combination.question_id.to_i)
    end
    return tagged_questions
  end

end

before do
  current_user
end

# Homepage (Root path)
get '/' do
  @title = 'Crowd-sourced test builders'
  # @tag1_questions = tagged_questions(1)
  # @tag2_questions = tagged_questions(2)
  # @tag3_questions = tagged_questions(3)
  # @tag4_questions = tagged_questions(4)
  # @tag5_questions = tagged_questions(5)
  # @tag6_questions = tagged_questions(6)
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

# Add New Test

get '/tests/new' do
  @title = 'Here are your tests, or create a new one!'
  @test = Test.new
  @user_tests = Test.where(user_id: session[:user_id]) # should do a partial here
  erb :'tests/new'
end

post '/tests' do
  @new_test= Test.new(
    name: params[:name],
    user_id: @auth_user.id,
    logo: nil
    )
  if @new_test.save
    redirect "/tests/#{@new_test.id}"
  else
    erb :'tests/new'
  end
end

# Show A Test

get '/tests/:id' do
  @test = Test.find_by(id: params[:id])
  current_questions = QuestionSelection.where(test_id: @test.id)
  current_questions_ids = []
  current_questions.each do |qt_combination|
    current_questions_ids << qt_combination.question_id
  end
  if current_questions_ids.empty?
    @questions = Question.all
  else
    @questions = Question.all.where("id NOT IN (?)", current_questions_ids)
  end
  erb :'tests/show'
end

# Edit An Existing Test (Add Questions To Test)

post '/question-selections' do
  @question_id = params[:question_id].to_i
  @test_id = params[:test_id].to_i
  @question_added = QuestionSelection.create(
   question_id: @question_id,
    test_id: @test_id
    )
  if @question_added.save
    @test = Test.find_by(id: params[:id])
    redirect "tests/#{@test_id}"
  else
    redirect '/'
  end
end

#   @id = params[:id]
  # mailto: "" content = " /tests/<%=@id%>"
get '/tests/:id/test_results/new' do 
  @test = Test.find_by(id: params[:id])
  @all_test_results = TestResult.where(test_id: params[:id])
  @new_result = TestResult.new
  erb :'test_results/new'
end

post '/tests/:id/test_results' do
  @test = Test.find_by(id: params[:id])
  @name = params[:name]
  @email = params[:email]
  answer_ids = params[:questions].flat_map do |i, q|
    q
  end
  correct = Answer.where(id: answer_ids, correct: true).count.to_f
  total = Test.find(@test.id).questions.count.to_f
  @test_result = TestResult.create(
    candidate_name: @name,
    candidate_email: @email,
    candidate_score: (correct/total),
    test_id: @test.id
    )
  binding.pry
  if @test_result
    redirect "/tests/#{@test.id}/test_results/new"
  else
    session[:error] = "You failed to put in a credential."
  end

end

# Edit An Existing Test (Remove Questions From A Test)

# Remove Questions From A Test

delete '/question-selections/:id' do
  @question = QuestionSelection.find(params[:id])
  @test_id = @question.test_id
  @question.destroy
  redirect "tests/#{@test_id}"
end

# Add New Question

get '/questions/new' do
  @title = 'Add a question to the library'
  @question = Question.new
  erb :'questions/new'
end

post '/questions' do

  @tags = params[:tags]
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

        if @tags
          @tags.each do |tag_name|
            QuestionTag.create(
            question_id: @question.id,
            tag_id: Tag.find_by(name: tag_name).id
            )
            end
        end
      end
    end
    redirect '/questions'
  else
    redirect 'questions/new'
  end

end

# Show A Question

get '/questions/:id' do
  @question = Question.find(params[:id])
  @user = User.find(@question.user_id)
  @title = "#{@question.content} created by #{@user.name}"
  @other_questions_from_this_user = Question.where(user_id: @user.id).where.not(id: params[:id])
  erb :'questions/show'
end

# Delete A Question

get '/questions/:id/delete' do
  Question.find(params[:id]).destroy
  redirect :'questions'
end

# List All Questions Organized By Page

get '/questions' do
  @questions_per_page = 5
  @all_questions = Question.all.order(created_at: :desc)
  if params[:sort_by]
    case params[:sort_by]
    when 'rating'
      @all_questions = Question.all
      @all_questions.sort {|q1, q2| q1.average_rating <=> q2.average_rating}
    when 'popularity'
      @all_questions = Question.all
      @all_questions.sort {|q1, q2| q1.ratings_count <=> q2.ratings_count}
    end
  end
  if params[:limit]
    @all_questions = @all_questions.limit(params[:limit])
  else
    @all_questions = @all_questions.limit(@questions_per_page)
  end
  if params[:offset]
    @all_questions = @all_questions.offset(params[:offset])
  end
  if params[:term]
    @all_questions = @all_questions.where('username LIKE ? OR bio LIKE ?', "%#{term}%")
  end
  @all_questions
  erb :'questions/index'
end

# Show A Tag

get '/tags/:id' do
  @tag = Tag.find(params[:id])
  @tagged_questions = []
  QuestionTag.where(tag_id: @tag.id).each do |qt_combination|
    @tagged_questions << Question.find(qt_combination.question_id.to_i)
  end
  @title = "All questions tagged with: #{@tag.name}"
  erb :'tags/show'
end

# Rate A Question

post '/ratings/:id' do
  @question = Question.find(params[:id])
  @rating = Rating.create(
    question_id: @question.id,
    user_id:  @auth_user.id,
    value: params[:question_rating]
  )
  redirect :"questions/#{@question.id}"
end

# Remove Rating From A Question

get '/ratings/delete/:id' do
  @question = Question.find(Rating.find(params[:id]).question_id)
  Rating.find(params[:id]).destroy
  redirect :"questions/#{@question.id}"
end
