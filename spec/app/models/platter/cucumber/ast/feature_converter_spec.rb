describe Platter::Cucumber::Ast::FeatureConverter do

  describe "A Platter::Cucumber::Ast::FeatureConverter converting feature text and lines", :shared => true do

    before(:all) do
      name = <<-FEATURE_CONTENT
#{@feature_prefix}Some Feature Title
  First Line Text
  Second Line Text
  Third Line Text
FEATURE_CONTENT
      @feature = parse_feature(name)
    end

    it "should parse the title from the Cucumber::Ast::Feature name first line" do
      @feature.title.should eql("Some Feature Title")
    end

    it "should parse the lines from the Cucumber::Ast::Feature name" do
      %w(First Second Third).each_with_index do |line_text_prefix, line_counter|
        @feature.lines[line_counter].text.should eql("#{line_text_prefix} Line Text")
      end
    end

    def parse_feature(cucumber_ast_feature_name)
      cucumber_ast_feature = Platter::Cucumber::Ast::FeatureConverter.stub_instance(:name => cucumber_ast_feature_name)
      Platter::Cucumber::Ast::FeatureConverter.new(cucumber_ast_feature).convert
    end

  end


  context "#convert" do

    describe "when provided a Cucumber::Ast::Feature" do

      describe "with a name that includes a feature prefix" do

        before(:all) do
          @feature_prefix = "Feature: "
        end

        it_should_behave_like "A Platter::Cucumber::Ast::FeatureConverter converting feature text and lines"
      end

      describe "with a name that excludes a feature prefix" do

        before(:all) do
          @feature_prefix = ""
        end

        it_should_behave_like "A Platter::Cucumber::Ast::FeatureConverter converting feature text and lines"
      end

    end

  end

end
