namespace :import do

  desc "Imports a directory containing features and/or features nested within sub-directories.  A folder will be created for each sub-directory."
  task :features => :environment do
    raise "path to feature directory must be provided" unless ENV["path"]
    imported_features = Platter::Cucumber::FeatureImporter.import_directory(ENV["path"])
    SimpleLog.info "#{imported_features.size} features successfully imported"
  end

end
