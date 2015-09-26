class CandidateAnswer < ActiveRecord::Base

	belongs_to :test_result
	belongs_to :question
	belongs_to :answer

	# before_save :correct?

	# def correct?
	# 	if self.test_result_id && self.question_id && self.answer_id
	# 		self.correct = true
	# 	else
	# 		self.correct = false
	# 	end
	# 	correct.save
	# end

end