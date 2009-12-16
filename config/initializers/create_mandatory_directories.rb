[Platter::Feature::IMPORT_DIRECTORY, Platter::Feature::EXPORT_DIRECTORY, Platter::Folder::EXPORT_DIRECTORY].each do |directory|
  FileUtils.mkdir_p(directory)
end
