BDD_TOOL_SERVICES = { :cucumber => { :adapter => Shrink::Cucumber::FeatureAdapter,
                                     :file_manager => Shrink::Cucumber::FeatureFileManager } }
BDD_TOOL = BDD_TOOL_SERVICES[:cucumber]

FEATURE_IMPORTER = Shrink::FeatureImporter.new(BDD_TOOL[:adapter], BDD_TOOL[:file_manager])
FOLDER_IMPORTER = Shrink::FolderImporter.new(FEATURE_IMPORTER)

FEATURE_EXPORTER = Shrink::FeatureExporter.new(BDD_TOOL[:adapter])
FOLDER_EXPORTER = Shrink::FolderExporter.new(BDD_TOOL[:adapter])
