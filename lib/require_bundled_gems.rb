require "rubygems"
require "bundler"

raise "Bundler version 1.2.1 required." unless Bundler::VERSION == "1.2.1"

ENV["BUNDLE_GEMFILE"] = File.expand_path(File.dirname(__FILE__) + "/../Gemfile")
Bundler.setup
