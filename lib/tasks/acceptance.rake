desc "Exercises all acceptance tests via a test server"
task :acceptance do
  Rake::Task["server:test:start"].invoke
  begin
    Rake::Task["cucumber:all"].invoke
  ensure
    Rake::Task["server:test:stop"].invoke
  end
end
