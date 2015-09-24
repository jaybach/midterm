class Answer < ActiveRecord::Base

  belongs_to :question

  validates :content, presence: true, length: { minimum: 1, maximum: 50 }

end
