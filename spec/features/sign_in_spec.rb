require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    #save_and_open_page
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  cenario 'User can sign in with Github account' do
    click_on "Sign in with GitHub"
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario 'App handles an authentication error from Github' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    click_on "Sign in with GitHub"
    expect(page).to have_content 'Invalid credentials'
  end

  scenario 'User can sign in with vkontakte account' do
    click_on "Sign in with vkontakte"
    expect(page).to have_content 'Successfully authenticated from vkontakte account.'
  end

  scenario 'App handles an authentication error from vkontakte' do
    OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
    click_on "Sign in with vkontakte"
    expect(page).to have_content 'Invalid credentials'
  end
end
