namespace :db do

  redefine_task(:load_config) do
    require 'active_record'
    require Rails.root.join('lib/extensions/gems/active_record/init')

    ActiveRecord::Base.configurations = Rails.configuration.database_configuration
    ActiveRecord::Migrator.migrations_paths = Rails.application.paths['db/migrate'].to_a
    if defined?(ENGINE_PATH) && engine = Rails::Engine.find(ENGINE_PATH)
      if engine.paths['db/migrate'].existent
        ActiveRecord::Migrator.migrations_paths += engine.paths['db/migrate'].to_a
      end
    end
  end

  namespace :test do

    desc "Loads seed data from db/seeds.rb into the test database"
    task :seed => :environment do
      establish_connection
      Rake::Task["db:seed"].execute
    end

    desc "Copies the development schema to the test database and seeds the test database"
    task :prepare_and_seed => %w(db:test:prepare db:test:seed)

    desc "Clears the test database, only seed data remains"
    task :clear => :environment do
      establish_connection
      require Rails.root.join('lib/shrink/database')
      Shrink::Database.clear
    end

    def establish_connection
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
    end

  end

  desc "Migrates the development database and synchronizes the test database"
  task :migrate_and_prepare => %w(db:migrate db:test:prepare_and_seed)

  desc "Resets the development database and synchronizes the tests database"
  task :reset_and_prepare => %w(db:migrate:reset db:seed db:test:prepare_and_seed)

end
