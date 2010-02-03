describe Shrink::ProjectSteps do

  describe "integrating with the database" do
    it_should_behave_like DatabaseIntegration

    context "#find_similar_texts" do

      it_should_behave_like "A find_similar_texts model method returning persisted texts similar to the text provided"

      before(:all) do
        create_project
        create_scenarios
        create_steps(@all_texts)

        @model = Shrink::ProjectSteps.new(@project)
      end

      def create_project
        @project = create_project!
      end

      def create_scenarios
        @scenarios = (1..3).collect do |i|
          feature = create_feature!(:title => "Feature #{i}", :folder => @project.root_folder)
          create_scenario!(:feature => feature, :title => "Scenario #{i}")
        end
      end

      def create_steps(texts)
        texts.each_with_index { |text, i| Shrink::Step.create!(:text => text, :scenario => @scenarios[i % 3]) }
      end

    end

  end

end
