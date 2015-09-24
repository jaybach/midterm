class Question < ActiveRecord::Base

  belongs_to :user
  belongs_to :test
  has_many :question_tags
  has_many :tags, through: :question_tags

  validates :content, length: { minimum: 5, maximum: 200 }

end
