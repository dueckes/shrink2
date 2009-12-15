describe Platter::Feature do

  describe "integrating with the database" do

    before(:each) do
      @feature = DatabaseModelFixture.create_feature!
    end

    context "#valid?" do

      describe "when a title is established" do

        describe "and the title is the same as another features title in the same folder" do

          before(:each) do
            DatabaseModelFixture.create_feature!(:title => "Same Title", :folder => @feature.folder)
            @feature.title = "Same Title"
          end

          it "should return false" do
            @feature.should_not be_valid
          end

        end

        describe "and the title is the same as another features title in a different folder" do

          before(:each) do
            different_folder = DatabaseModelFixture.create_folder!(:name => "Different Folder")
            DatabaseModelFixture.create_feature!(:title => "Same Title", :folder => different_folder)
            @feature.title = "Same Title"
          end

          it "should return true" do
            @feature.should be_valid
          end

        end

      end

    end

    context "#tags" do
      
      describe "when tags have been added" do

        before(:each) do
          %w(a_name z_name m_name).each do |tag_name|
            @feature.tags << Platter::Tag.find_or_create!(:name => tag_name)
          end
          @feature.tags(true)
        end

        it "should have the same amount of tags that have been added" do
          @feature.tags.should have(3).tags
        end

        it "should be ordered in descending order of tag name" do
          @feature.tags.collect(&:name).should eql(%w(a_name m_name z_name))
        end

      end

    end

    context "#description_lines" do

      describe "when description lines have been added" do

        before(:each) do
          (1..3).each do |i|
            @feature.description_lines << Platter::FeatureDescriptionLine.new(:text => "Description Line Text #{i}", :position => 4 - i)
          end
          @feature.description_lines(true)
        end

        it "should have the same amount of description lines that have been added" do
          @feature.description_lines.should have(3).description_lines
        end

        it "should be ordered by position" do
          @feature.description_lines.each_with_index do |description_line, i|
            description_line.text.should eql("Description Line Text #{3 - i}")
          end
        end

      end

    end

    context "#scenarios" do

      describe "when scenarios have been added" do

        before(:each) do
          (1..3).each do |i|
            @feature.scenarios << Platter::Scenario.new(:title => "Scenario Title #{i}", :position => 4 - i)
          end
          @feature.scenarios(true)
        end

        it "should have the same amount of scenarios that have been added" do
          @feature.scenarios.should have(3).scenarios
        end

        it "should be ordered by position" do
          @feature.scenarios.each_with_index { |scenario, i| scenario.title.should eql("Scenario Title #{3 - i}") }
        end

      end

    end

    context "when saved" do

      it "should calculate and establish the summary once" do
        @feature.should_receive(:calculate_summary).once.and_return("Some Summary")

        @feature.update_attributes!(:title => "Some Updated Title")

        @feature.summary.should eql("Some Summary")
      end

      it "should calculate and establish the base filename" do
        @feature.should_receive(:calculate_base_filename).once.and_return("Some file name")

        @feature.update_attributes!(:title => "Some Updated Title")

        @feature.base_filename.should eql("Some file name")
      end

    end

    context "#update_summary!" do

      it "should evaluate and establish the summary once" do
        @feature.should_receive(:calculate_summary).once.and_return("Some Summary")

        @feature.update_summary!

        @feature.summary.should eql("Some Summary")
      end

    end

  end

end
