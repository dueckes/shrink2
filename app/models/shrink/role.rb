module Shrink

  class Role < ::ActiveRecord::Base

    def administrator?
      name == "administrator"
    end
  end

end
