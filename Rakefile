# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path(File.dirname(__FILE__) + "/config/boot")
require File.expand_path(File.dirname(__FILE__) + "/rake_initializer")

CLEAN << "#{RAILS_ROOT}/build"

desc "Clears build directory, exercises all migrations, seeds database, performs metrics checks and executes all behaviors with coverage analysis"
task :ci => ["clean", "db:reset_and_prepare", "metrics:check", "spec:rcov"]

desc "Exercises all migrations, seeds database, executes all behaviors"
task :pre => ["db:reset_and_prepare", :spec]

task :default => :pre
