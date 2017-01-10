Given /^the space "([^"]*)" has a category "([^"]*)"(?: with (\d+) resources)?$/ do |space_name, category_name, resource_count|
  space = Space.find_by_name!(space_name)
  category = space.categories.create! name: category_name
  (resource_count || 0).to_i.times do |i|
    category.resources.create! name: "#{category_name} #{i+1}"
  end
end

When /^I add the category "([^"]*)" with (\d+) resources$/ do |name, no_of_resources|
  click_link 'Add Category'
  fill_in 'Name', with: name
  fill_in 'No. of resources', with: no_of_resources
  click_button 'Add Category'
end

When /^I remove the category "([^"]*)"$/ do |name|
  visit spaces_path
  click_link name
  click_link 'Remove Category'
end

Then /^I should see no category "([^"]*)"$/ do |name|
  visit spaces_path
  expect(page).to have_no_css('*', text: name)
end