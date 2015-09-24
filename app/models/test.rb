class Test < ActiveRecord::Base

  belongs_to :user
  has_many :test_results
  has_many :questions

end
