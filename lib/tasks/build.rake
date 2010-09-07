CLEAN << "#{RAILS_ROOT}/build"

desc "Clears build directory, exercises all migrations, seeds database, performs metrics checks and executes all behaviors with coverage analysis"
task :ci => ["clean", "db:reset_and_prepare", "metrics:check", "spec:rcov"]

desc "Exercises all migrations, seeds database, executes all behaviors"
task :dev => ["db:reset_and_prepare", :spec]
