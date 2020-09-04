require 'rails_helper'

feature 'User can register in the system', %q(
  To create questions and answers, the user must register
) do
  background { visit new_user_registration_path }

  describe 'User registered in the system' do

    scenario 'Registered correct' do
      fill_in 'Email', with: 'new_user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'Registered incorrect' do
      click_button 'Sign up'
      expect(page).to have_content "Email can't be blank"
    end
  end
end
