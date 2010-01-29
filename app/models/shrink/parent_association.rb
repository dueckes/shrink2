module Shrink

  class ParentAssociation
    attr_reader :name, :model_class

    def initialize(options)
      @name = options[:name]
      @model_class = options[:model_class] || ::Shrink::ModelReflections.class_for(options[:name])
    end

  end

end
