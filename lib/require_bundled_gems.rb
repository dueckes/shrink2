require "rubygems"
require "bundler"

raise "Bundler version 1.0.0 required." unless Bundler::VERSION == "1.0.0"

ENV["BUNDLE_GEMFILE"] = File.expand_path(File.dirname(__FILE__) + "/../Gemfile")
Bundler.setup
