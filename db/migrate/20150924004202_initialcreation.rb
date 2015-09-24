class Initialcreation < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, null: false
      t.string :password, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :company, null: false
      t.string :avatar
      t.timestamps null: false
    end

    create_table :tests do |t|
      t.references :user
      t.string :name, null: false
      t.string :logo
      t.timestamps null: false
    end

    create_table :question_selections do |t|
      t.references :test
      t.references :question
      t.timestamps null: false
    end

    create_table :test_results do |t|
      t.references :test
      t.string :candidate_name, null: false
      t.string :candidate_email, null: false
      t.string :candidate_score, null: false
      t.timestamps null: false
    end

    create_table :questions do |t|
      t.references :user
      t.string :content, null: false
      t.string :image
      t.timestamps null: false
    end

    create_table :question_tags do |t|
      t.references :question
      t.references :tag
      t.timestamps null: false
    end

    create_table :tags do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :answers do |t|
      t.references :question
      t.string :content, null: false
      t.boolean :correct, null: false
      t.timestamps null: false
    end

    create_table :ratings do |t|
      t.references :question
      t.references :user
      t.integer :value
      t.timestamps null: false
    end
  end
end
