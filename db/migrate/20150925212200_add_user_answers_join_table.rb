class AddUserAnswersJoinTable < ActiveRecord::Migration
  
  def change
  	create_table :candidate_answers do |t|
  		t.references :test_result
  		t.references :question
  		t.references :answer
  		t.boolean :correct, null: false
  		t.timestamps null: false
  	end
  end

end
