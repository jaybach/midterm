class AddCorrectToAnswers < ActiveRecord::Migration
  def change
  	change_table :answers do |t|
  		t.string :content, null: false
  	end
  end
end
