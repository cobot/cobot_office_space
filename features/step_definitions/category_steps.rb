When /^I add the category "([^"]*)" with (\d+) resources$/ do |name, no_of_resources|
  click_link 'Add Category'
  fill_in 'Name', with: name
  fill_in 'No. of resources', with: no_of_resources
  click_button 'Add Category'
end

Then /^I should see a category "([^"]*)" with the resources "([^"]*)"$/ do |name, offices|
  click_link 'Home'
  click_link name
  offices.split('/').each do |office|
    page.should have_css('*', text: office)
  end
end