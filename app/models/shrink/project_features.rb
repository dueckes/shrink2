module Shrink

  module ProjectFeatures
    include ::Shrink::ActiveRecord::OptionManipulation

    def most_recently_changed(limit)
      all(:order => "updated_at desc", :limit => limit)
    end

    private
    def project
      proxy_association.owner
    end

    def merge_find_options_with_defaults(options)
      merge_options_including_conditions(options, default_find_options)
    end

  end

end
