Given /^I am logged in$/ do
    OmniAuth.config.mock_auth[:cobot] ||= {
    "credentials"=>{"token"=>"12345"},
    "user_info"=>{"name"=>"janesmith", 
        "email"=>"janesmith@example.com"}, 
    "extra"=>{
      "user_hash"=>{
        "memberships"=>[], 
        "admin_of"=>[]
      }
    }
  }

  visit root_path
  click_link "Sign in"
end

Then /^I should be signed out$/ do
  page.should have_no_css('*', text: 'Sign out')
end