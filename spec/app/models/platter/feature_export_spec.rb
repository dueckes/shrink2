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

  describe Feature, '#export_name'  do
    it 'should use the title' do
      title = 'some_title'
      Feature.new(:title => title).export_name.should eql title
    end

    it 'should replace spaces with underscores' do
      Feature.new(:title => 'title with spaces').export_name.should eql 'title_with_spaces'
    end
    
    it 'should downcase the title' do
      Feature.new(:title => 'Title WITH MIXED cAse').export_name.should eql 'title_with_mixed_case'
    end

    it 'should drop all non alpha numeric characters' do
      Feature.new(:title => 'T1tle !@#$%with n0n alph4 numeric +)(*&^characters and numb3rs').export_name.should eql "t1tle_with_n0n_alph4_numeric_characters_and_numb3rs"      
    end
  end
end