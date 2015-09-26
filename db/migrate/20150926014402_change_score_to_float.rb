class ChangeScoreToFloat < ActiveRecord::Migration
  def change
  	change_column :test_results, :candidate_score, :float
  	remove_column :candidate_answers, :correct, :boolean
  end
end
