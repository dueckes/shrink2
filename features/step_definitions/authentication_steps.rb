When /^the user signs-in as an? (.*)$/ do |role_name|
  step "the user visits the sign-in page"
  step "the page should be shown without error"
  @current_page.sign_in(find_role(role_name))
end

Given /^a signed-in user$/ do
  step "the user signs-in as an administrator"
end
