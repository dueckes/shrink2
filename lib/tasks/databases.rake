namespace :db do

  redefine_task(:load_config => :rails_env) do
    require 'active_record'
    require File.expand_path("#{RAILS_ROOT}/lib/extensions/frameworks/active_record/init")
    ActiveRecord::Base.configurations = Rails::Configuration.new.database_configuration
  end

  namespace :test do

    desc "Loads seed data from db/seeds.rb into the test database"
    task :seed => :environment do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
      Rake::Task["db:seed"].execute
    end

  end

  desc "Resets the development database and synchronizes the tests database"
  task :reset_and_prepare => %w(db:migrate:reset db:seed db:test:prepare db:test:seed)

end
