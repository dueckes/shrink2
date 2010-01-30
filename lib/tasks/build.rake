desc "Resets and prepares test database, exercising all migrations and executes all behaviors"
task :full => ["db:reset_and_prepare", :spec]

task :default => :full
