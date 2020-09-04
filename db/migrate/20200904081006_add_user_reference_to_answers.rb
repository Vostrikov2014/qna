class AddUserReferenceToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :user, foreign_keys: true
  end
end
