class CandidateAnswer < ActiveRecord::Base

	belongs_to :test_result
	belongs_to :question
	belongs_to :answer

	validates :email, uniqueness: true, format: { with: /.+@.+\..{2,}/i, :message => "Enter a valid Email address !" }

end
