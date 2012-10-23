module Shrink

  class FeatureExporter

    def initialize(feature_adapter)
      @feature_adapter = feature_adapter
    end

    def export(options)
      FileUtils.mkdir_p(options[:destination_directory])
      @feature_adapter.to_file(options[:feature], File, options[:destination_directory])
    end

  end

end
