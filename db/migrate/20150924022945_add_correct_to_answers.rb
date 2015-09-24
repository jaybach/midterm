class AddCorrectToAnswers < ActiveRecord::Migration
  def change
  	change_table :answers do |t|
  		t.string :content
  	end
  end
end
