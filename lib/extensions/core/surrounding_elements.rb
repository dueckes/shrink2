class SurroundingElements

  def initialize(array, center_element, length)
    @array = array
    @center_element = center_element
    @length = length
    raise "Element #{@center_element} does not exist in #{@array}" if index_of(@center_element).nil?
    raise "Length must be > 0" if @length <= 0
  end

  def first
    @array[starting_index]
  end

  def last
    @array[ending_index]
  end

  private
  def index_of(element)
    @array.find_index { |array_element| array_element == element }
  end

  def starting_index
    center_index = index_of(@center_element)
    if center_index - @length < 0 || @array.length <= maximum_total_length
      0
    elsif center_index + @length > @array.length - 1
      @array.length - maximum_total_length
    else
      center_index - @length
    end
  end

  def ending_index
    starting_index + maximum_total_length > @array.length ?
            @array.length - 1 : starting_index + maximum_total_length - 1
  end

  def maximum_total_length
    @length * 2 + 1
  end

end
