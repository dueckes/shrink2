Rails::Initializer.class_eval do
  EXTENDED_GEMS = %w(active_record actionpack cucumber)
  EXTENDED_PLUGINS = %w(acts_as_list auto_complete)

  alias_method :load_gems_without_extensions, :load_gems
  def load_gems
    load_gems_without_extensions
    EXTENDED_GEMS.each do |gem_name|
      require File.expand_path("#{RAILS_ROOT}/lib/extensions/gems/#{gem_name}/init.rb")
    end
  end

  alias_method :load_plugins_without_extensions, :load_plugins
  def load_plugins
    load_plugins_without_extensions
    EXTENDED_PLUGINS.each do |plugin_name|
      require File.expand_path("#{RAILS_ROOT}/lib/extensions/plugins/#{plugin_name}/init.rb")
    end
  end

end
