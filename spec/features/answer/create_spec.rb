require 'rails_helper'

feature 'The user, being on the question page, can write the answer to the question', %q(
  An authenticated user can write an answer to a question to help solve a problem
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'writes the answer to the question' do
      fill_in 'Answer', with: 'Test answer'
      click_on 'Reply'

      expect(page).to have_content 'Your answer added'
      expect(page).to have_content 'Test answer'
    end

    scenario 'writes an answer to a question with errors' do
      click_on 'Reply'

      expect(page).to have_content "Answer can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'trying to answer a question' do
      visit question_path(question)
      click_on 'Reply'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end