require "rubygems"
require "bundler"

raise "Bundler version 0.9.26 required." unless Bundler::VERSION == "0.9.26"

ENV["BUNDLE_GEMFILE"] = File.expand_path(File.dirname(__FILE__) + "/../Gemfile")
Bundler.setup
