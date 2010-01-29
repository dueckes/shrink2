namespace :import do

  desc "Imports a directory containing features and/or features nested within sub-directories.  A folder will be created for each sub-directory."
  task :features => :environment do
    raise "path to feature directory must be provided" unless ENV["path"]
    imported_features = FEATURE_IMPORTER.import(:directory_path => ENV["path"])
    features_with_errors = imported_features.select { |feature| !feature.valid? }
    unless features_with_errors.empty?
      SimpleLog.info "Encountered #{features_with_errors.size} errors during import.  No features were imported."
      error_descriptions = features_with_errors.collect { |feature| feature.errors.full_messages }.flatten
      SimpleLog.info "Error details:\n#{error_descriptions.join("\n")}"
    else
      SimpleLog.info "#{imported_features.size} features successfully imported"
    end
  end

end
