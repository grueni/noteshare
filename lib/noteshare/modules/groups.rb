module Noteshare

  ########## GROUPS   #############

  def groups
    data = groups_json || "[]"
    JSON.parse(data)
  end

  def set_groups(array)
    self.groups_json = array.to_json
    DocumentRepository.update self
  end

  def add_group(group)
    _groups = self.groups
    if (_groups.include? group) == false
      _groups << group
      self.set_groups _groups
    end
  end

  def delete_group(group)
    _groups = self.groups
    if (_groups.include? group)
      _groups.delete group
      self.set_groups _groups
    end
  end


end