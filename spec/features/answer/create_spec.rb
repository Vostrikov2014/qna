require 'rails_helper'

feature 'User can give an answer', %q{Only authenticated user can give a response} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'create answer' do
      fill_in 'Answer', with: 'My answer'
      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'My answer'
    end

    scenario 'create answer with errors' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'create answer' do
      visit question_path(question)
      click_on 'Reply'

      expect(page).to have_content 'You need to sign in continuing'
    end
  end
end
