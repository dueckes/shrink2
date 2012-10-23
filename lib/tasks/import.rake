namespace :import do

  desc "Imports a directory containing features and/or features nested within sub-directories.  A folder will be created for each sub-directory."
  task :features => :environment do
    raise "path=path/to_feature_directory must be provided" unless ENV["path"]
    project = determine_destination_project
    imported_features = FEATURE_IMPORTER.import(:directory_path => ENV["path"],
                                                :destination_folder => project.root_folder)
    features_with_errors = imported_features.select { |feature| !feature.valid? }
    unless features_with_errors.empty?
      SimpleLog.info "Encountered #{features_with_errors.size} errors during import.  No features were imported."
      error_descriptions = features_with_errors.collect { |feature| feature.errors.full_messages }.flatten
      SimpleLog.info "Error details:\n#{error_descriptions.join("\n")}"
    else
      SimpleLog.info "#{imported_features.size} features successfully imported into project '#{project.name}'"
    end
  end

  private

  def determine_destination_project
    if ENV["project"]
      project = Shrink::Project.find_by_name(ENV["project"])
      project.tap { raise "project '#{ENV["project"]}' does not exist" unless project }
    else
      Shrink::Project.default
    end
  end

end
