describe Shrink::ProjectFolders do

  class TestableProjectFolders
    include Shrink::ProjectFolders
  end

  before(:each) do
    @project_folders = TestableProjectFolders.new
  end

  context "#count" do

    it "should return the project folders size" do
      @project_folders.stub!(:size).and_return(8)

      @project_folders.count.should eql(8)
    end

  end

end
