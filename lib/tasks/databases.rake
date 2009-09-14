namespace :db do

  redefine_task(:load_config => :rails_env) do
    require 'active_record'
    require File.expand_path("#{RAILS_ROOT}/lib/extensions/gems/active_record/active_record")
    ActiveRecord::Base.configurations = Rails::Configuration.new.database_configuration
  end

  desc "Resets the development database and synchronizes the tests database"
  task :reset_and_prepare => ["db:migrate:reset", "db:test:prepare"]

end
