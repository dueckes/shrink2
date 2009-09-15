require 'tmpdir'
module Platter
  describe Feature, '#export' do

    before :all do
      @title = 'some_title'
      @base_dir = Pathname.new(Dir.tmpdir)
      Feature.new(:title => @title).export @base_dir

    end
    it 'should create a file matching the feature title ' do
      Pathname.new(@base_dir + "#{@title}.feature").should exist
    end

    it 'the file should be in the directory passed as an argument' do
      Pathname.new(@base_dir + "#{@title}.feature").parent.should eql @base_dir
    end
  end
end