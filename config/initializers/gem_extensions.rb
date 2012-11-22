EXTENDED_GEMS = %w(actionpack active_record cucumber declarative_authorization).freeze
EXTENDED_GEMS.each do |gem_name|
  require Rails.root.join('lib', 'extensions', 'gems', gem_name, 'init')
end
