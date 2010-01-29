share_as :DatabaseIntegration do
  include DatabaseModelFixture

  it_should_behave_like ClearDatabaseAfterAll
end

share_as :ClearDatabaseAfterAll do

  after(:all) { destroy_all_models }

end

share_as :ClearDatabaseAfterEach do

  after(:each) { destroy_all_models }

end
