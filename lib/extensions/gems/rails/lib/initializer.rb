Rails::Initializer.class_eval do
  EXTENDED_FRAMEWORKS = %w(active_record).freeze
  EXTENDED_GEMS = %w(actionpack cucumber).freeze
  EXTENDED_PLUGINS = %w(acts_as_list auto_complete).freeze

  alias_method :require_frameworks_without_extensions, :require_frameworks
  def require_frameworks
    require_frameworks_without_extensions
    EXTENDED_FRAMEWORKS.each do |framework_name|
      require File.expand_path("#{RAILS_ROOT}/lib/extensions/frameworks/#{framework_name}/init.rb")
    end
  end

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
