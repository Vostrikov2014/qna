require 'rails_helper'

feature 'User can select best answer', %q(Show me best answer) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, user: user, question: question) }

  describe 'Only author can be select best answer' do
    background { user.author?(question) }

    scenario 'select best answer', js: true do
      visit question_path(question)

      answers.each do |answer|
        within "#answer-#{answer.id}" do
          click_on 'Select best!'
          expect(page).to have_content 'This is the best answer!'
          expect(page).to_not have_link 'Select best!'
        end
      end

      expect(page.all('.best-answer-title').size).to eq 1
    end

    scenario 'tries select best answer for another question' do
      visit question_path(other_question)
      expect(page).to_not have_link 'Select best!'
    end
  end
end
