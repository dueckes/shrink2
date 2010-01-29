module Shrink

  module ProjectFeatures
    include ::Shrink::ActiveRecord::OptionManipulation

    def paginate(*args)
      Shrink::Feature.paginate(*[args[0..-2], merge_find_options_with_defaults(args[-1])].flatten)
    end

    def most_recently_changed(limit)
      find(:all, :order => "updated_at desc", :limit => limit)
    end

    def count
      size
    end

    private
    def project
      proxy_owner
    end

    def merge_find_options_with_defaults(options)
      merge_options_including_conditions(options, default_find_options)
    end

    def default_find_options
      { :joins => "inner join folders on (folders.id = features.folder_id)",
        :conditions => ["folders.project_id = ?", project.id] }
    end

  end

end
