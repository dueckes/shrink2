module Cucumber
  module Ast

    # Patch description
    # Exposes feature_elements (aka scenarios)
    #
    Feature.instance_eval do
      attr_reader :feature_elements
    end

  end
end
