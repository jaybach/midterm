class Test < ActiveRecord::Base

  belongs_to :user
  has_many :test_results
  has_many :question_selections
  has_many :questions, :through => :question_selections	

end
