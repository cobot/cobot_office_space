Given /^I am logged in$/ do
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:cobot] ||= {
    'credentials' => {
      'token' => '12345'
    },
    'info' => {
      'name' => 'janesmith',
      'email' => 'janesmith@example.com'
    },
    'extra' => {
      'raw_info' => {
        'memberships' => [],
        'admin_of' => []
      }
    }
  }

  visit root_path
  2.times { click_link 'Sign in' }
end

Then /^I should be signed out$/ do
  expect(page).to have_no_css('*', text: 'Sign out')
end
