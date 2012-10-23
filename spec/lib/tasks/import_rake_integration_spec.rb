describe ":import" do

  context ":features" do

    describe "integrating with the database" do
      it_should_behave_like DatabaseIntegration

      describe "when a directory containing multiple feature files is provided" do

        before(:all) do
          @result = Rake::TaskExecutor.execute(
                  :task => "import:features",
                  :environment_variables => { :path => "#{SPEC_RESOURCES_DIR}/directory_with_many_valid_features" })

          @expected_feature_titles = ["First Feature Title", "Second Feature Title", "Third Feature Title"]
        end

        it "should execute without error indicating the number of features imported" do
          @result.exit_status.should eql(0)
          @result.output.should include("#{@expected_feature_titles.size} features successfully imported")
        end

        it "should persist the imported feature" do
          @expected_feature_titles.each do |feature_name|
            Shrink::Feature.find_by_title(feature_name).should_not be_nil
          end
        end

      end

    end

  end

end
