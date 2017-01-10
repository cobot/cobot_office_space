When /^I remove the resource "([^"]*)"$/ do |name|
  visit spaces_path
  click_link name.sub(/\s\d+$/, '')
  click_link name
  click_link 'Remove Resource'
end

When /^I add the resource "([^"]*)"$/ do |name|
  visit spaces_path
  click_link name.sub(/\s\d+$/, '')
  click_link 'Add Resource'
  fill_in 'Name', with: name
  click_button 'Add Resource'
end

Then /^I should see a category "([^"]*)" with the resources "([^"]*)"$/ do |name, offices|
  visit space_path(Space.last)
  click_link name
  offices.split('/').each do |office|
    page.should have_css('*', text: office)
  end
end

Then /^I should see that the category "([^"]*)" has no resource "([^"]*)"$/ do |category_name, resource_name|
  visit space_path(Space.last)
  click_link category_name
  page.should have_no_css('*', text: resource_name)
end
