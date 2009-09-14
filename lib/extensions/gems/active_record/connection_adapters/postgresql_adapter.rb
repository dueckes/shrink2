class PGconn

  def self.quote_ident(name)
    %("#{name}")
  end

end
