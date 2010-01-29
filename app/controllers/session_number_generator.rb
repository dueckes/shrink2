module SessionNumberGenerator

  def current_number(symbol)
    params[symbol].blank? ? next_number(symbol) : params[symbol]
  end

  def next_number(symbol)
    session[symbol] ||= 0
    session[symbol] = session[symbol] + 1
  end

end
