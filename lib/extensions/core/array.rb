Array.class_eval do

  def hasherize(&block)
    hash = {}
    self.each_with_index { |element, position| hash.merge!(element_to_hash(element, position, &block)) }
    hash
  end

  def collect_with_index(&block)
    array = []
    self.each_with_index do |element, i|
      array << block.call(element, i)
    end
    array
  end

  def find_index(if_none=nil, &block)
    matching_element = self.find &block
    matching_element ? self.index(matching_element) : if_none
  end

  def preview(focus_index, preview_length, excluded_content_indicator="...")
    starting_index = starting_preview_index(focus_index, preview_length)
    elements = self[starting_index, preview_length]
    elements = [excluded_content_indicator] + elements if starting_index > 0
    elements = elements + [excluded_content_indicator] if starting_index + preview_length - 1 < self.length - 1
    elements
  end

  private
  def element_to_hash(element, position, &hash_block)
    key, value = nil
    if hash_block.arity == 1
      key, value = hash_block.call(element)
    elsif hash_block.arity != 0
      key, value = hash_block.call(element, position)
    end
    { key => value }
  end

  def starting_preview_index(focus_index, preview_length)
    if focus_index <= 0 || self.length < preview_length + 1
      0
    elsif self.length - focus_index < preview_length
      self.length - preview_length
    else
      focus_index - 1
    end
  end


end
