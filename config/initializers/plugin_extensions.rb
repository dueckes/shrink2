EXTENDED_PLUGINS = %w(acts_as_list auto_complete).freeze
EXTENDED_PLUGINS.each do |plugin_name|
  require Rails.root.join('lib', 'extensions', 'plugins', plugin_name, 'init')
end
