BDD_TOOL_SERVICES = { :cucumber => { :adapter => Platter::Cucumber::FeatureAdapter,
                                     :file_manager => Platter::Cucumber::FeatureFileManager } }
BDD_TOOL = BDD_TOOL_SERVICES[:cucumber]

FEATURE_IMPORTER = Platter::FeatureImporter.new(BDD_TOOL[:adapter], BDD_TOOL[:file_manager])
FOLDER_IMPORTER = Platter::FolderImporter.new(FEATURE_IMPORTER)

FEATURE_EXPORTER = Platter::FeatureExporter.new(BDD_TOOL[:adapter])
FOLDER_EXPORTER = Platter::FolderExporter.new(BDD_TOOL[:adapter])
