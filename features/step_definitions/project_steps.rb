When /^the user creates a project$/ do
  @project_name = "Project #{Shrink::Project.count + 1} Name"
  @current_page.add(@project_name)
end

When /^a project has been created$/ do
  project = create_project!
  @project_name = project.name
end

When /^the user views the project$/ do
  @current_page.view(@project_name)
end

Then /^a link to the project is shown in the project list$/ do
  @current_page.wait_until_project_link_is_shown!(@project_name)
end

Then /^the details of the project are shown$/ do
  @current_page.wait_until_details_are_shown!(@project_name)
end

