class Settings
  include Lotus::Entity

  attributes :owner, :id, :dict


  def set_key(key, value)
    dict[key] = value
  end

  def get_key(key)
    dict[key]
  end

  def delete_key(key)
    dict.delete(key)
  end

  def clear
    self.dict = {}
  end

  def set(hash)
    self.dict = hash
  end

  def as_string
    self.dict.to_s
  end

  def update
    SettingsRepository.update self
  end

end
