require 'tmpdir'
module Platter
  describe Feature, '#export' do

    before :all do
      @title = 'feature_title'
      @base_dir = Pathname.new(Dir.tmpdir)
      @feature_file = Pathname.new(@base_dir + "#{@title}.feature")
      feature = Feature.new(:title => @title)
      feature.stub!(:as_text).and_return 'feature text'
      feature.export @base_dir
      @feature_file_contents = @feature_file.readlines
    end
    
    it 'should create a file matching the feature title ' do
      @feature_file.should exist
    end
    
    it 'the file should be in the directory passed as an argument' do
      @feature_file.parent.should eql @base_dir
    end

    it 'should include #as_text as contents of the file' do
      @feature_file_contents.should include 'feature text'
    end
    
  end
end