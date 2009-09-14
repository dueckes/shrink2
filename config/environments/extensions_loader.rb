puts "Loading extensions loader"
EXTENDED_GEMS = %w(active_record)
EXTENDED_GEMS.each do |gem_name|
  puts "Extending gem #{gem_name}"
  require File.expand_path("#{RAILS_ROOT}/lib/extensions/#{gem_name}/#{gem_name}.rb")
end
