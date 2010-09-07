class RecordingLog

  class << self

    def info(message, &block)
      messages << message
    end

    def messages
      @messages ||= []
    end

    def reset
      messages.clear
    end

  end

end
