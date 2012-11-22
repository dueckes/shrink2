describe Shrink::ProjectFeatureDescriptionLines do

  describe "integrating with the database" do
    include_context "database integration"

    context "#find_similar_texts" do

      include_examples "a find_similar_texts model method returning persisted texts similar to the text provided"

      before(:all) do
        create_project
        create_valid_feature
        create_description_lines(@all_texts)

        @model = Shrink::ProjectFeatureDescriptionLines.new(@project)
      end

      def create_project
        @project = create_project!
      end

      def create_valid_feature
        @feature = create_feature!(:project => @project)
      end

      def create_description_lines(texts)
        texts.each { |text| Shrink::FeatureDescriptionLine.create!(:text => text, :feature => @feature) }
      end

    end

  end

end
