# ACL is a take-off unix Access Control Lists
# An ACL wil be implemented as a hash.  For example,
# consider the ACL listed below;

##  user::rw-
##
##  user:genie:rw-
##
##  group::r–
##
##  group:mega:r
##
##  mask::rw-
##
##  other::r–

# it is represented by the hash
#
#  'user': 'rw-', 'user:genie': 'rw-', 'group':  'r-',
#      'group:mega': 'r-', 'mask': 'rw-', 'other': 'r'


# $ setfacl -m user:genie:rw turkey.txt
# $ setfacl -m genie:rw- turkey.txt
# $ setfacl -m group::rw turkey.txt
# $ setfacl -x genie turkey.txt
# $ setfacl -x user:genie turkey.txt


module ACL

  def acl_info
    acl.each do |key, value|
      puts "#{key} => #{value}".red
    end
  end


  def acl_get(key)
    acl[key]
  end

  def acl_set_permissions(u,g,w)
    acl['user']  = u
    acl['group'] = g
    acl['world'] = w
  end

  def acl_set_permissions!(u,g,w)
    acl_set_permissions(u,g,w)
    DocumentRepository.update self
  end

  def acl_set_permission(key, value)
    if [:user, :group, :world].include? key or key =~ /user:/
      acl[key.to_s] = value
    end
  end

  def acl_set_permission!(key, value)
    acl_set_permission(key, value)
    DocumentRepository.update self
  end

  def acl_unset_permission(key)
    if [:user, :group, :world].include? key
      acl[key.to_s] = '-'
    end
  end

  def acl_unset_permission!(key)
    acl_unset_permission(key)
    DocumentRepository.update self
  end

  def acl_set(key, identifier, value)
    if [:user, :group, :world].include? key
      acl["#{key.to_s}:#{identifier}"] = value
    end
  end

  def acl_delete(key, identifier)
    if [:user, :group, :world].include? key
      acl.delete "#{key.to_s}:#{identifier}"
    end
  end

  ######################################

  def self.set_world_readable(document)
    document.acl_set_permission(:world, 'r')
    DocumentRepository.update document
  end

  def self.unset_world_readable(document)
    document.acl_set_permission(:world, '-')
    DocumentRepository.update document
  end

  def self.toggle_world_readable(document)
    if document.acl_get(:world) =~ /r/
      document.acl_unset_permission!(:world)
    else
      document.acl_set_permission!(:world, 'r')
    end
  end

  def self.toggle_world_readable_for_tree(document)
    if document.acl_get(:world) =~ /r/
      document.apply_to_tree(:acl_unset_permission, [:world])
    else
      document.apply_to_tree(:acl_set_permission, [:world, 'r'])
    end
  end

  def self.set_permissions_for_tree(document, u, g, w)
      document.apply_to_tree(:acl_set_permissions!, [u, g, w])
  end

  ######################################

  def self.set_all_permissions_to(u,g,w)
    DocumentRepository.all.each do |doc|
      doc.acl_set_permissions(u,g,w)
      DocumentRepository.update(doc)
    end
    DocumentRepository.all.count
  end


end

