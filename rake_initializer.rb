require 'rake'
require File.expand_path(File.dirname(__FILE__) + "/lib/extensions/rake/redefine_task")
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/clean'

require 'tasks/rails'
