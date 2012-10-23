 module Shrink

  class FeatureTag < ::ActiveRecord::Base
    belongs_to :feature, :class_name => "Shrink::Feature"
    belongs_to :tag, :class_name => "Shrink::Tag"
  end

end
