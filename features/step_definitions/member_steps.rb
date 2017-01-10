When /^I assign "([^"]*)" to "([^"]*)"$/ do |member_name, resource_name|
  visit spaces_path
  click_link resource_name.sub(/\s\d+$/, '')
  click_link resource_name
  select member_name, from: 'Member'
  click_button 'Assign Member'
end

Then /^I should see that "([^"]*)" is assigned to "([^"]*)"$/ do |member_name, resource_name|
  visit spaces_path
  click_link resource_name.sub(/\s\d+$/, '')
  expect(page).to have_xpath("//*[contains(., '#{member_name}')][contains(., '#{resource_name}')]")
end
