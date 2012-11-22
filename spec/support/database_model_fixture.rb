require Rails.root.join('lib/shrink/database')

module DatabaseModelFixture

  def create_project!(options={})
    default_options = { :name => "Project #{Shrink::Project.count + 1} Name" }
    combined_options = default_options.merge(options)
    Shrink::Project.create!(combined_options)
  end

  def find_or_create_project!(options={})
    Shrink::Project.first || create_project!(options)
  end

  def create_folder!(options={})
    default_options = { :name => "Folder Name" }
    combined_options = default_options.merge(options)
    combined_options[:project] = find_or_create_project! unless combined_options[:project] || combined_options[:parent]
    Shrink::Folder.create!(combined_options)
  end

  def find_or_create_folder!(options={})
    Shrink::Folder.first || create_folder!(options)
  end

  def create_feature!(options={})
    combined_options = { :title => "Feature Title" }.merge(options)
    combined_options[:folder] = find_or_create_folder! unless combined_options[:folder]
    combined_options[:project] = find_or_create_project! unless combined_options[:folder] || combined_options[:project]
    Shrink::Feature.create!(combined_options)
  end

  def find_or_create_feature!(options={})
    Shrink::Feature.first || create_feature!(options)
  end

  def create_tag!(options={})
    default_options = { :name => "Tag #{Shrink::Tag.count + 1} Name" }
    combined_options = default_options.merge(options)
    combined_options[:project] = find_or_create_project! unless combined_options[:project]
    Shrink::Tag.create!(combined_options)
  end

  def create_description_line!(options={})
    default_options = { :text => "Feature Description Line Text" }
    combined_options = default_options.merge(options)
    combined_options[:feature] = find_or_create_feature! unless combined_options[:feature]
    Shrink::FeatureDescriptionLine.create!(combined_options)
  end

  def create_scenario!(options={})
    combined_options = { :title => "Scenario Title" }.merge(options)
    combined_options[:feature] ||= find_or_create_feature!
    Shrink::Scenario.create!(:feature => combined_options[:feature], :title => combined_options[:title])
  end

  def create_table!(dimensions={})
    combined_dimensions = { :rows => 0, :columns => 0 }.merge(dimensions)
    table = Shrink::Table.create!
    (1..combined_dimensions[:rows]).collect do |row_number|
      row = table.rows.create
      (1..combined_dimensions[:columns]).each do |column_number|
        row.cells.create(:text => "Cell #{row_number}.#{column_number}")
      end
    end
    table
  end

  def create_user!(options={})
    default_options = { :login => "User Login", :password => "password", :password_confirmation => "password" }
    combined_options = default_options.merge(options)
    combined_options[:role] = find_role! unless combined_options[:role]
    Shrink::User.create!(combined_options)
  end

  def find_role!
    Shrink::Role.first
  end

  def create_model!(model_class, options={})
    self.send("create_#{model_class.short_name}!", options)
  end

  def create_project_with_folders_and_features!(project_name)
    project = create_project!(:name => project_name)
    parent_folder = project.root_folder
    (1..3).each do |folder_number|
      folder_name = "#{project_name} folder #{folder_number}"
      folder = create_folder!(:name => folder_name, :parent => parent_folder)
      (1..3).each do |feature_number|
        feature_name = "#{folder_name} feature #{feature_number}"
        create_feature!(:folder => folder, :title => feature_name)
      end
      parent_folder = folder
    end
    project
  end

  def destroy_all_models
    Shrink::Database.clear
  end

end
