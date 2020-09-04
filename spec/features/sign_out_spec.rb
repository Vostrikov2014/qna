require 'rails_helper'

feature 'User can log_out', %q(
  The user must be able to log out to end the session
) do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'User log out' do
    login(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

end
