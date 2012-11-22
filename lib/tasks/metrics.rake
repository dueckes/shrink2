namespace :metrics do

  SRC_DIRECTORIES = %w(app config/initializers lib)

  desc "Reports on source code metrics"
  task :check => ["metrics:roodi", "metrics:reek"]

  desc "Reports on source code metrics via Roodi"
  task :roodi => :environment do
    source_files = SRC_DIRECTORIES.collect { |dir| all_ruby_files_in(dir) }.join(" ")
    SimpleLog.info "Analyzing #{source_files}"
    write_report("roodi", `roodi #{source_files}`)
  end

  desc "Reports on source code metrics via Reek"
  task :reek => :environment do
    source_files = all_ruby_files_in("app/models")
    SimpleLog.info "Analyzing #{source_files}"
    write_report("reek", `reek #{source_files}`)
  end

  def all_ruby_files_in(dir)
    "#{Rails.root}/#{dir}/**/*.rb"
  end

  def write_report(tool_name, content)
    SimpleLog.info content

    report_directory = Rails.root.join('build', 'metrics')
    report_file_name = "#{report_directory}/#{tool_name}.txt"
    FileUtils.mkdir_p report_directory
    File.open(report_file_name, "w") { |file| file << content }
    SimpleLog.info "\nSee report in #{report_file_name}"
  end

end
