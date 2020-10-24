require 'rails_helper'

feature 'features/question/create_spec.rb - Пользователь может создавать тесты / User can create tests', %q{
  Чтобы получить ответ от сообщества / To get a response from the community
  Как аутентифицированный пользователь / As an authenticated user
} do

  given(:user) { create(:user) }

  describe 'Аутентифицированный пользователь / Authenticated user', js: true do
    background do
      login(user)

      visit questions_path
      click_on 'New question'
    end

    scenario 'задать вопрос / asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'создать пустой вопрос / asks a question with title be blank' do
      click_on 'Ask'

      expect(page).to have_content ""
    end

    scenario 'пользователь может добавить один или несколько файлов при создании вопроса / user can add one or more files when creating a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Неаутентифицированный пользователь пытается создать вопрос / Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'New question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
