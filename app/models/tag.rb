class Tag < ActiveRecord::Base

  has_many :question_tags
  has_many :questions, through: :question_tags

  validates :name, presence: true, length: { minimum: 2, maximum: 25 }

end
