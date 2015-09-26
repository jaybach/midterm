class QuestionSelection < ActiveRecord::Base
	# self.table_name = "question_selections"
	belongs_to :question
	belongs_to :test
	validates :question_id, uniqueness: {scope: :test_id}

end
