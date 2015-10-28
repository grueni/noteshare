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

  # Map 'foo: 123, bar: 456, baz:' to {'foo': 123, 'bar': 456}
  def hash_value(arg = {})
    key_value_separator = arg[:key_value_separator] || ':'
    item_separator = arg[:item_separator] || ','
    items = self.split(item_separator)
    items = items.map{ |item| item.strip }
    hash = {}
    items.each do |item|
      a, b = item.split(key_value_separator)
      a = a.strip
      b = b.strip if b
      b ||= ''
      hash[a] = b
    end
    hash
  end

end