module Shrink
  module Rails

    class LocalServer

      PID_DIR = File.join(::Rails.root, "tmp/pids")
      LOG_DIR = File.join(::Rails.root, "log")

      def initialize(environment, port)
        @environment = environment
        @port = port
      end

      def start!
        raise "#{@environment} server already running" if running?
        ensure_directories_exist
        Process.fork { Process.exec("rails s -e #{@environment} -p #{@port} -P #{pid_file_path} > #{console_log_file_path} 2>&1") }
      end

      def stop!
        raise "#{@environment} server not running" unless running?
        Process.kill("INT", current_pid)
        File.delete(pid_file_path)
      end

      def status
        running? ? "started" : "stopped"
      end

      def to_s
        "#{@environment.to_s.capitalize} server on port #{@port}"
      end

      private

      def running?
        !current_pid.nil?
      end

      def current_pid
        File.exists?(pid_file_path) ? File.read(pid_file_path).to_i : nil
      end

      def pid_file_path
        File.join(PID_DIR, "#{@environment}_server.pid")
      end

      def console_log_file_path
        File.join(LOG_DIR, "#{@environment}_console.log")
      end

      def ensure_directories_exist
        FileUtils.mkdir_p([PID_DIR, LOG_DIR])
      end

    end

  end
end
