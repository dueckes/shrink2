describe Platter::Feature do

  describe "integrating with the database" do

    before(:each) do
      @feature = DatabaseModelFixture.create_feature!
    end

    describe "#lines" do

      describe "when lines have been added" do

        before(:each) do
          (1..3).each do |i|
            @feature.lines << Platter::FeatureLine.new(:text => "Feature Line Text #{i}", :position => 4 - i)
          end
        end

        it "should have the same amount of lines that have been added" do
          @feature.lines.should have(3).lines
        end

        it "should be ordered by position" do
          @feature.lines.each_with_index do |line, i|
            line.position.should eql(i + 1)
            line.text.should eql("Feature Line Text #{3 - i}")
          end
        end

      end

    end

    describe "#scenarios" do

      describe "when scenarios have been added" do

        before(:each) do
          (1..3).each do |i|
            @feature.scenarios << Platter::Scenario.new(:title => "Scenario Title #{i}", :position => 4 - i)
          end
        end

        it "should have the same amount of scenarios that have been added" do
          @feature.scenarios.should have(3).scenarios
        end

        it "should be ordered by position" do
          @feature.scenarios.each_with_index do |scenario, i|
            scenario.position.should eql(i + 1)
            scenario.title.should eql("Scenario Title #{3 - i}")
          end
        end

      end

    end

  end

end
