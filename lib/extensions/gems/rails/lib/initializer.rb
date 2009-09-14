Rails::Initializer.class_eval do
  EXTENDED_GEMS = %w(active_record)
  EXTENDED_PLUGINS = %w(acts_as_list)

  alias_method :load_gems_without_extensions, :load_gems
  def load_gems
    load_gems_without_extensions
    EXTENDED_GEMS.each do |gem_name|
      puts "Extending gem #{gem_name}"
      Dir.glob(File.expand_path("#{RAILS_ROOT}/lib/extensions/gems/#{gem_name}/**/*.rb")).each { |file| require(file) }
    end
  end

  alias_method :load_plugins_without_extensions, :load_plugins
  def load_plugins
    load_plugins_without_extensions
    EXTENDED_PLUGINS.each do |plugin_name|
      puts "Extending plugin #{plugin_name}"
      Dir.glob(File.expand_path("#{RAILS_ROOT}/lib/extensions/plugins/#{plugin_name}/**/*.rb")).each { |file| require(file) }
    end
  end

end
