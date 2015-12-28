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

  def update
    SettingsRepository.update self
  end

end
