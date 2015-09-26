class Question < ActiveRecord::Base

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_selections, dependent: :destroy
  has_many :tests, :through => :question_selections
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags
  has_many :ratings
  has_many :answers

  validates :content, length: { minimum: 5, maximum: 200 }

  def average_rating
    self.ratings.average(:value).to_f.round(2)
  end

  def ratings_count
    self.ratings.count
  end

end
