describe Shrink::ProjectTags do

  class TestableProjectTags
    include Shrink::ProjectTags
  end

  before(:each) do
    @project_tags = TestableProjectTags.new
  end

  context "#count" do

    it "should return the tags size" do
      @project_tags.stub!(:size).and_return(88)

      @project_tags.count.should eql(88)
    end

  end

end
