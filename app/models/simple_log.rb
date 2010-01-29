class SimpleLog

  def self.info(*args, &block)
    args.each { |arg| puts arg }
  end

end
