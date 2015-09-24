class Question < ActiveRecord::Base

  belongs_to :user
  has_many :question_selections
  has_many :tests, :through => :question_selections
  has_many :question_tags
  has_many :tags, through: :question_tags

  validates :content, length: { minimum: 5, maximum: 200 }

end
