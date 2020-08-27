class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.text :body
      t.references :question, null: false, foreign_keys: true

      t.timestamps
    end
  end
end
