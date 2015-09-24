class User < ActiveRecord::Base

  has_many :tests, dependent: :destroy
  has_many :question_selections
  has_many :ratings

  validates :user_name, uniqueness: true
  validates :email, uniqueness: true, format: { with: /.+@.+\..{2,}/i, :message => "Enter a valid Email address !" }

end
