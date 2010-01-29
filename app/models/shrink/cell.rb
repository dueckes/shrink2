module Shrink

  class Cell < ::ActiveRecord::Base
    belongs_to :row, :class_name => "Shrink::Row"
    acts_as_list :scope => :row

    def table
      row.table
    end
    
  end

end
