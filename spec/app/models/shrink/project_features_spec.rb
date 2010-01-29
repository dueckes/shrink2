describe Shrink::ProjectFeatures do

  class TestableProjectFeatures
    include Shrink::ProjectFeatures

    attr_reader :proxy_object

    def initialize(proxy_object)
      @proxy_object = proxy_object
    end
    
  end

  before(:each) do
    @project_features = TestableProjectFeatures.new(Shrink::Project.new)
  end

  context "#most_recently_changed" do

    describe "when provided with the number of features to retrieve" do

      before(:each) do
        @limit = 8
      end

      it "should limit the number of features returned to the number provided" do
        @project_features.should_receive(:find).with(:all, hash_including(:limit => 8))

        @project_features.most_recently_changed(@limit)
      end

      it "should order the features found so that the limit retrieves the most recent" do
        @project_features.should_receive(:find).with(anything, hash_including(:order => "updated_at desc"))

        @project_features.most_recently_changed(@limit)
      end

      it "should return the features found" do
        features = (1..3).collect { |i| Shrink::Feature.new(:title => "Feature #{i}") }
        @project_features.stub!(:find).and_return(features)

        @project_features.most_recently_changed(@limit).should eql(features)
      end

    end

  end

  context "#count" do

    it "should return the features size" do
      @project_features.stub!(:size).and_return(8)

      @project_features.count.should eql(8)
    end

  end

end
