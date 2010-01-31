namespace :build do

  desc "Clears the build directory"
  task :clean => :environment do
    FileUtils.rm_rf("#{RAILS_ROOT}/build")
  end

end

desc "Clears build directory, exercises all migrations, seeds database, performs metrics checks and executes all behaviors with coverage analysis"
task :ci => ["build:clean", "db:reset_and_prepare", "metrics:check", "spec:rcov"]

desc "Exercises all migrations, seeds database, executes all behaviors"
task :dev => ["db:reset_and_prepare", :spec]

task :default => :dev
