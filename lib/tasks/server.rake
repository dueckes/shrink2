namespace :server do

  namespace :test do

    require File.expand_path(File.join(__FILE__, '../../shrink/rails/local_server'))
    TEST_SERVER = Shrink::Rails::LocalServer.new(:test, 3001)

    desc "Starts a local test server running the local codebase"
    task :start do
      TEST_SERVER.start!
      puts "#{TEST_SERVER} started"
    end

    desc "Stops a running local test server"
    task :stop do
      TEST_SERVER.stop!
      puts "#{TEST_SERVER} stopped"
    end

    desc "Indicates the status of the local test server"
    task :status do
      puts "#{TEST_SERVER} is #{TEST_SERVER.status}"
    end

  end

end


