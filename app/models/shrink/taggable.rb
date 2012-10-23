module Shrink

  module Taggable

    def self.included(model_class)
      join_class_name = "#{model_class.name}Tag"
      join_method_name = "#{model_class.short_name}_tags".to_sym
      model_class.has_many join_method_name, :class_name => join_class_name, :dependent => :destroy
      model_class.has_many :tags, :through => join_method_name, :order => :name, :extend => Shrink::FeatureConstituentTags
      model_class.set_tag_adapter Shrink::Cucumber::Ast::Adapter::TagAdapter
    end

  end

end
