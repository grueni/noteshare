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


  def acl_get(key)
    acl[key]
  end

  def acl_set_permissions(u,g,w)
    acl['user']  = u
    acl['group'] = g
    acl['world'] = w
  end

  def acl_set_permission(key, value)
    if [:user, :group, :world].include? key
      acl[key.to_s] = value
    end
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

  def self.set_all_permissions_to(u,g,w)
    DocumentRepository.all.each do |doc|
      doc.acl_set_permissions(u,g,w)
      DocumentRepository.update(doc)
    end
    DocumentRepository.all.count
  end


end

