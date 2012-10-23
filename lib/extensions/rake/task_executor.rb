module Rake

  class TaskExecutor

    def self.execute(options)
      environment_variable_string = options[:environment_variables].inject("") do |result, variable|
        "#{result} #{variable[0].to_s}=#{variable[1]}"
      end.strip
      command = "rake #{environment_variable_string} #{options[:task]} --trace"
      puts "Executing rake command: #{command}"
      output = `#{command}`
      ExecutionResult.new($?.exitstatus, output)
    end

  end

  class ExecutionResult

    attr_accessor :exit_status, :output

    def initialize(exit_status, output)
      @exit_status = exit_status
      @output = output
    end

  end

end
