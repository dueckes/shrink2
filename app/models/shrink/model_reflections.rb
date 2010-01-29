module Shrink

  class ModelReflections

    class << self
      
      def class_for(name)
        ::Shrink.const_get(name.to_s.capitalize)
      end

    end

  end

end
