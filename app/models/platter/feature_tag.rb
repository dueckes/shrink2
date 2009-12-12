module Platter

  class FeatureTag < ::ActiveRecord::Base
    belongs_to :feature, :class_name => "Platter::Feature"
    belongs_to :tag, :class_name => "Platter::Tag"
  end

end
