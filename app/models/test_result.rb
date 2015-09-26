class TestResult < ActiveRecord::Base

	belongs_to :test
	#validates :note, length: {minimum: 2}
end
