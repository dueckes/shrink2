Array.class_eval do

  def hasherize(&block)
    hash = {}
    self.each_with_index { |element, position| hash.merge!(element_to_hash(element, position, &block)) }
    hash
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
