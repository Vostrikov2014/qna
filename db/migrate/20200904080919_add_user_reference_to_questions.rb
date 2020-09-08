class AddUserReferenceToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :user, foreign_keys: true
  end
end
