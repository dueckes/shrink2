require 'rake'
require File.expand_path("../lib/extensions/rake/redefine_task", __FILE__)
require 'rake/testtask'
require 'rake/clean'

require 'rdoc/task'

Shrink::Application.load_tasks
