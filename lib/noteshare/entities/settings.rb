class Settings
  include Lotus::Entity

  attributes :owner, :id, :raw_hash

  def hash
    JSON.parse(self.raw_hash || "{}")
  end

  def set_hash(h)
    self.raw_hash = h.to_json
  end

  def set_key(key, value)
    h = self.hash
    h[key] = value
    set_hash(h)
  end

  def get_key(key)
    hash[key]
  end

  def delete_key(key)
    h = self.hash
    h.delete(key)
    set_hash(h)
  end

  def hash_as_string
    hash.to_s
  end

  def update
    SettingsRepository.update self
  end

end
