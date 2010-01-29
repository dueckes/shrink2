describe Shrink::ProjectFeatures do

  describe "integrating with the database" do
    it_should_behave_like DatabaseIntegration

    describe "when multiple projects with nested folders containing features with tags have been created" do

      before(:all) do
        project = create_project_with_folders_and_features!("A Project")
        create_project_with_folders_and_features!("Another Project")

        @all_project_feature_titles = (1..3).collect do |i|
          (1..3).collect { |j| "A Project folder #{i} feature #{j}" }
        end.flatten

        @project_features = project.features
      end

      context "#find" do

        describe "when provided conditions" do

          describe "and features match the conditions" do

            before(:all) do
              @features = @project_features.find(:all, :conditions => ["title like ?", "% folder 2 feature %"])
            end

            it "should return all features in the project matching the conditions" do
              expected_feature_titles = (1..3).collect { |i| "A Project folder 2 feature #{i}" }

              @features.collect(&:title).sort.should eql(expected_feature_titles)
            end

          end

          describe "and features match the conditions" do

            before(:all) do
              @features = @project_features.find(:all, :conditions => ["title = ?", "Does not match"])
            end

            it "should return an empty array" do
              @features.should be_empty
            end

          end

        end

        describe "when provided no conditions" do

          before(:all) do
            @features = @project_features.find(:all)
          end

          it "should return features whose folders are associated with the project" do
            @features.collect(&:title).sort.should eql(@all_project_feature_titles)
          end

        end

      end

      context "#most_recently_changed" do

        describe "when provided a number of changes limit" do

          it "should execute without error" do
            lambda { @project_features.most_recently_changed(3) }.should_not raise_error
          end

        end

      end

      context "#paginate" do

        describe "when provided a page number of 1" do

          describe "and the results per page is less than the total number of results" do

            before(:all) do
              find_paginated_features_ordered_by_title(:page => 1, :per_page => 8)
            end

            it "should return the first results limited to the number of results per page" do
              @feature_titles.should eql(@all_project_feature_titles[0..-2])
            end

          end

          describe "and the results per page matches the total number of results" do

            before(:all) do
              find_paginated_features_ordered_by_title(:page => 1, :per_page => 9)
            end

            it "should return all possible results" do
              @feature_titles.should eql(@all_project_feature_titles)
            end

          end

          describe "and the results per page exceeds the total number of results" do

            before(:all) do
              find_paginated_features_ordered_by_title(:page => 1, :per_page => 10)
            end

            it "should return all possible results" do
              @feature_titles.should eql(@all_project_feature_titles)
            end

          end

        end

        describe "when provided a page number greater than 1" do

          describe "when there is a sufficient total number of results for the page number and results per page provided" do

            before(:all) do
              find_paginated_features_ordered_by_title(:page => 2, :per_page => 6)
            end

            it "should return the results" do
              @feature_titles.should eql(@all_project_feature_titles[6..-1])
            end

          end

          describe "when there is not a sufficient total number of results for the page number and results per page provided" do

            before(:all) do
              find_paginated_features_ordered_by_title(:page => 2, :per_page => 9)
            end

            it "should return an empty array" do
              @features.should be_empty
            end

          end

        end

        describe "when provided conditions" do

          describe "and features match the conditions" do

            before(:all) do
              find_paginated_features_ordered_by_title(:conditions => ["title like ?", "% folder 2 feature %"])
            end

            it "should return features limited to the page number and results per page provided" do
              expected_feature_titles = (1..3).collect { |i| "A Project folder 2 feature #{i}" }

              @feature_titles.should eql(expected_feature_titles)
            end

          end

          describe "and no features match the conditions" do

            before(:all) do
              find_paginated_features_ordered_by_title(:conditions => ["title = ?", "Does not match"])
            end

            it "should return an empty array" do
              @features.should be_empty
            end

          end

        end

        def find_paginated_features_ordered_by_title(options)
          @features = @project_features.paginate(
                  :all, { :order => "title asc", :page => 1, :per_page => 3 }.merge(options))
          @feature_titles = @features.collect(&:title)
        end

      end

      context "#count" do

        it "should return the number of features in all folders in the project" do
          @project_features.count.should eql(9)
        end

      end

    end

  end

end
