require 'tmpdir'
module Platter
  describe Feature, '#export' do

    before :all do
      @title = 'feature_title'
      @base_dir = Pathname.new(Dir.tmpdir)
      @feature_file = Pathname.new(@base_dir + "#{@title}.feature")
      @feature = Feature.new(:title => @title)
      @feature.lines <<  FeatureLine.new(:text => 'first feature line')
      @feature.lines <<  FeatureLine.new(:text => 'second feature line')
      @feature.scenarios <<  Scenario.new(:title => 'first scenario')
      @feature.scenarios <<  Scenario.new(:title => 'second scenario')
      @feature.export @base_dir
      @feature_file_contents = @feature_file.readlines.map &:chomp!
    end
    
    it 'should create a file matching the feature title ' do
      @feature_file.should exist
    end
    
    it 'the file should be in the directory passed as an argument' do
      @feature_file.parent.should eql @base_dir
    end

    it 'the file should contain the feature title' do
      @feature_file_contents.should include "Feature: #{@title}"
    end

    it 'the file should include & indent feature lines' do
      @feature.lines.each do | feature_line |
        @feature_file_contents.should include "  #{feature_line.text}"
      end
    end

    it 'the file should include scenarios' do
      @feature.scenarios.each do | scenario |
        @feature_file_contents.should include "Scenario: #{scenario.title}"
      end
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