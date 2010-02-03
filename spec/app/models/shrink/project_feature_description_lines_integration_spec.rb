describe Shrink::ProjectFeatureDescriptionLines do

  describe "integrating with the database" do
    it_should_behave_like DatabaseIntegration

    context "#find_similar_texts" do

      it_should_behave_like "A find_similar_texts model method returning persisted texts similar to the text provided"

      before(:all) do
        create_project
        create_feature
        create_description_lines(@all_texts)

        @model = Shrink::ProjectFeatureDescriptionLines.new(@project)
      end

      def create_project
        @project = create_project!
      end

      def create_feature
        @feature = create_feature!(:project => @project)
      end

      def create_description_lines(texts)
        texts.each { |text| Shrink::FeatureDescriptionLine.create!(:text => text, :feature => @feature) }
      end

    end

  end

end
