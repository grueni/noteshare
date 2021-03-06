class Array

  # Returns the sublist of elements with
  # index > k.  This, if foo = [0, 1, 2, 3, 4, 5],
  # then foo.tail(3) /=> [4, 5]. It is always the
  # case that foo = foo.head(k) + foo.tail(k)
  def tail(k)
    return [] if self == []
    n = self.length
    return self if k >= n
    self[k+1, n - k-1]
  end

  # Returns the sublist of elements with
  # index > k.  This, if foo = [0, 1, 2, 3, 4, 5],
  # then foo.head(3) /=> [0, 1, 2, 3]. It is always the
  # case that foo = foo.head(k) + foo.tail(k)
  def head(k)
    return [] if self == []
    n = self.length
    return self if k >=  n
    self[0, k+1]
  end

  def permute(permutation)
    return self if self.count != permutation.count
    array = []
    permutation.each do |k|
      array << self[k]
    end
    array
  end



  # [10, 11, 12, 13]].random_indices(2)
  #=> 0, 2 (for example)
  def random_indices(number_of_indices)
    output = []
    count = 0
    while output.count < number_of_indices and count < 2*number_of_indices do
      j = SecureRandom.random_number(self.count)
      if !output.include? j
        output << j
      end
      count += 1
    end
    return output
  end

  def random_sublist(size)

    output = []
    indices = random_indices(size)
    indices.each do |index|
      output << self[index]
    end
    return output

  end
end

class Hash

  def string_val(style=:horizontal)
    out = ''
    case style
      when :vertical
        terminator = "\n"
      when :vertical_strict
        terminator = ";\n"
      when :horizontal
        terminator = ", "
      else
        terminator = ", "
    end
    self.each do |key, value|
      out << "#{key}: #{value}" << terminator
    end
    out = out[0..-3] if style == :horizontal
    out
  end

end

class String
  def blue
    "\e[1;34m#{self}\e[0m"
  end

  def green
    "\e[1;32m#{self}\e[0m"
  end

  def red
    "\e[1;31m#{self}\e[0m"
  end

  def yellow
    "\e[1;33m#{self}\e[0m"
  end

  def magenta
    "\e[1;35m#{self}\e[0m"
  end

  def cyan
    "\e[1;36m#{self}\e[0m"
  end

  def white
    "\e[1;37m#{self}\e[0m"
  end

  def black
    "\e[1;30m#{self}\e[0m"
  end
end


class String

  # 'foo123bar'.alpha_filter => 'foobar'
  # 'foo123bar(' ')'.alpha_filter => 'foobar'
  #
  def alpha_filter(substitution_character = '')
    gsub(/[^a-zA-Z_]/, substitution_character)
  end

  def alpha_num_filter(substitution_character = '')
    gsub(/[^a-zA-Z0-9_]/, substitution_character)
  end

  def is_integer?
    (self =~ /^[0-9]*$/) == 0
  end

  # Map "It's cool!" to 'its_cool``
  def normalize(option='alpha')
    case option
      when 'alpha'
        self.gsub(' ', '_').downcase.alpha_filter
      when 'alphanum'
        self.gsub(' ', '_').downcase.alpha_num_filter
      else
        self.gsub(' ', '_').downcase.alpha_filter
    end

  end

  # Map 'foo: 123, bar: 456, baz:' to {'foo': 123, 'bar': 456}
   def hash_value(arg=':,')
    str ||= ''
    key_value_separator = arg[0] || ':'
    item_separator = arg[1] || ','
    str = str.strip
    if item_separator == "\n"
      str = self.gsub(/\n\n*/m, "\n")
    else
      str = self
    end
    items = str.split(item_separator)
    items = items.map{ |item| item.strip }
    hash = {}
    items.each do |item|
      a, b = item.split(key_value_separator)
      if a
        a = a.strip
        b = b.strip if b
        b ||= ''
        hash[a] = b
      end
    end
    hash
    end

  # Assume that the receive is of the form
  # "foo, bar, baz".  Return a list of the form
  # ['foo', 'bar', 'baz']
  def to_list
    self.split(',').map{ |str| str.strip }
  end

  # Assume that the receive is of the form
  # "foo, 1;  bar, 2;  baz, 3".  Return a list of the form
  # [['foo', '1'], ['bar', '2'], ['baz', '3']]
  def to_pair_list
    list = self.split(';').map{ |str| str.strip }
    list_of_pairs = []
    list.each do |item|
      pair = item.hash_value(",;")
      list_of_pairs << pair
    end
    list_of_pairs
  end



end