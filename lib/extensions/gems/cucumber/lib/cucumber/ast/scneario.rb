module Cucumber
  module Ast

    # Patch description
    # Exposes steps
    #
    Scenario.instance_eval do
      attr_reader :steps
    end

  end
end
