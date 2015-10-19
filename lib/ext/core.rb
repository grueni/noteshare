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
