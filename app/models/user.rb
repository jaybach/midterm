class User < ActiveRecord::Base

  has_many :tests, dependent: :destroy
  has_many :questions
  has_many :ratings

  validates :username, uniqueness: true
  validates :email, uniqueness: true, format: { with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/, :message => "Enter a valid Email address !" }

end
