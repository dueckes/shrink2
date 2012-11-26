share_examples_for "database integration" do
  include Shrink::DatabaseModelFixture

  include_context "clear database after all"
end

share_examples_for "clear database after all" do

  after(:all) { destroy_all_models }

end

share_examples_for "clear database after each" do

  after(:each) { destroy_all_models }

end
