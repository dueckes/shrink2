When /^I navigate to the homepage$/ do
  visit('/')
end

Then /^the page should be shown without error$/ do
  page.should have_content("Shrink - confide and benefit")
  page.should_not have_content("error")
end
