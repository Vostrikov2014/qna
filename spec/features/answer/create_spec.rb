require 'rails_helper'

feature 'features/answer/create_spec.rb - Пользователь может отвечать / User can give an answer', %q{
  Только аутентифицированный пользователь может дать ответ / Only authenticated user can give a response
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Аутентифицированный пользователь / Authenticated user', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'ответить на вопрос / answer the question' do
      fill_in 'Answer', with: 'Test answer'
      click_on 'Reply'

      #expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'создать пустой ответ / replay answer with body be blank' do
      click_on 'Reply'

      expect(page).to have_content ""
    end

    scenario 'Authentication user create answer with error' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'прикрепить файл к ответу / replay a question with attached file' do
      fill_in 'Answer', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Reply'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Только автор ответа может редакировать ответ / Only author can edit the answer', js: true do
    scenario 'редактировать ответ / edit answer' do
      visit question_path(question)

      expect(page).to_not have_button 'Edit'
    end
  end
end
