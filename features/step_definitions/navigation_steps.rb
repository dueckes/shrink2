Given /^(?:a|the) user visits the (.*) page$/ do |page_name|
  @current_page = find_page(page_name)
  @current_page.visit
  @current_page.wait_until_shown!
end

Given /^the user is on the (.*) page$/ do |page_name|
  @current_page = find_page(page_name)
  @current_page.wait_until_shown!
end

Then /^the page should be shown without error$/ do
  @current_page.wait_until_shown_without_error!
end

Then /^the (.*) page should be shown$/ do |page_name|
  @current_page = find_page(page_name)
  step "the page should be shown without error"
end
