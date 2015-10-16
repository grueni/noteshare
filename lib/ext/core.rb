class Array
  def tail(k)
    return [] if self == []
    n = self.length
    return self if k >= n
    self[k+1, n - k-1]
  end
end