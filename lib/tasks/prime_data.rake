namespace :prime do

  namespace :data  do

    FEATURE_TITLE_PREFIX = "Rake Feature"
    PROJECT_NAME = "Data Priming Project"

    desc "creates X number of features in the data priming project, declared via number=X or 1 if no number is provided"
    task :features => :environment do
      number_to_create = ENV["number"] ? ENV["number"].to_i : 1
      raise "number must be > 0" unless number_to_create > 0
      SimpleLog.info "Creating #{number_to_create} feature(s)..."
      largest_persisted_feature_number = find_largest_persisted_feature_number
      (1..number_to_create).each do |feature_number|
        Shrink::Feature.create!(:folder => root_folder,
                                :title => "#{FEATURE_TITLE_PREFIX} #{largest_persisted_feature_number + feature_number}")
      end
      SimpleLog.info "#{number_to_create} features successfully created in project named: #{PROJECT_NAME}"
    end

    def find_largest_persisted_feature_number
      features = find_or_create_data_priming_project.features.find(
              :all, :conditions => ["title like ?", "#{FEATURE_TITLE_PREFIX} %"])
      features.collect do |feature|
        feature_number_match = feature.title.match(/^#{FEATURE_TITLE_PREFIX} (\d*)$/)
        feature_number_match ? feature_number_match[1].to_i : 0
      end.sort.last || 0
    end

    def root_folder
      find_or_create_data_priming_project.root_folder
    end

    def find_or_create_data_priming_project
      Shrink::Project.find_by_name(PROJECT_NAME) || Shrink::Project.create!(:name => PROJECT_NAME)
    end

  end

end
