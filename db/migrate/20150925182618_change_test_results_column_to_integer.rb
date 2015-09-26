class ChangeTestResultsColumnToInteger < ActiveRecord::Migration
  def change
  	change_column :test_results, :candidate_score, :integer

  end
end
