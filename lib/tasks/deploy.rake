namespace :deploy do

  desc "Deploys trunk to production"
  task :production do
    puts "Deploying to production..."
    puts `git push heroku master`
    puts "Done"
  end

end
