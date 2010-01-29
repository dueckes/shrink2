module Shrink

  module FeatureTags

    def line
      self.collect(&:name).join(", ")
    end

    def line=(line)
      tag_names = line.split(",").collect(&:strip).uniq
      add(tag_names)
      remove(tag_names)
      feature.update_summary!
    end

    def project=(project)
      self.each_with_index do |tag, i|
        self[i] = Shrink::Tag.find_or_new(:name => tag.name, :project => project) unless tag.project
      end
    end

    def unused
      project.tags.find(:order => "name") - self
    end

    private
    def project
      feature.project
    end

    def feature
      proxy_owner
    end

    def add(names)
      feature_tag_names = self.collect(&:name)
      added_tag_names = names.find_all { |tag_name| !feature_tag_names.include?(tag_name) }
      added_tag_names.each { |tag_name| self << Shrink::Tag.find_or_create!(:name => tag_name, :project => project) }
    end

    def remove(names)
      removed_tags = self.find_all { |tag| !names.include?(tag.name) }
      removed_tags.each { |tag| self.delete(tag) }
    end

  end

end
