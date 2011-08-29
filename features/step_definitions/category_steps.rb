When /^I add the category "([^"]*)" with (\d+) offices$/ do |name, no_of_offices|
  click_link 'Add Category'
  fill_in 'Name', with: name
  fill_in 'No. of offices/desks', with: no_of_offices
end

Then /^I should see a category "([^"]*)" with the offices "([^"]*)"$/ do |name, offices|
  click_link 'Categories'
  click_link name
  offices.split('/').each do |office|
    page.should have_css('*', text: office)
  end
end