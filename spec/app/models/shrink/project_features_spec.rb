describe Shrink::ProjectFeatures do

  class TestableProjectFeatures
    include Shrink::ProjectFeatures

    attr_reader :proxy_object

    def initialize(proxy_object)
      @proxy_object = proxy_object
    end
    
  end

  let(:project_features) { TestableProjectFeatures.new(Shrink::Project.new) }

  context "#most_recently_changed" do

    describe "when provided with the number of features to retrieve" do

      let(:limit) { 8 }

      it "should limit the number of features returned to the number provided" do
        project_features.should_receive(:all).with(hash_including(:limit => 8))

        project_features.most_recently_changed(limit)
      end

      it "should order the features found so that the limit retrieves the most recent" do
        project_features.should_receive(:all).with(hash_including(:order => "updated_at desc"))

        project_features.most_recently_changed(limit)
      end

      it "should return the features found" do
        features = (1..3).collect { |i| Shrink::Feature.new(:title => "Feature #{i}") }
        project_features.stub!(:all).and_return(features)

        project_features.most_recently_changed(limit).should eql(features)
      end

    end

  end

end
