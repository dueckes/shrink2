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

end
