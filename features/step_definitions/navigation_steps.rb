When /^I visit the (.*) page$/ do |page_name|
  @current_page = find_page(page_name)
  @current_page.visit
end

When /^I sign-in as an? (.*)$/ do |role_name|
  step "I visit the sign-in page"
  step "the page should be shown without error"
  @current_page.sign_in(find_role(role_name))
end

Then /^the page should be shown without error$/ do
  @current_page.should be_shown_without_error
end

Then /^the (.*) page should be shown$/ do |page_name|
  @current_page = find_page(page_name)
  step "the page should be shown without error"
end
