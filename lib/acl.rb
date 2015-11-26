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


class ACL

  attr_accessor :hash

  def initialize
    @hash={}
  end

  def self.init_from_hash(hash)
    acl = ACL.new()
    acl.hash = hash
    return acl
  end

  def lookup(key)
    @hash[key]
  end

  def set_user(user, value)
    @hash['user:'+user]=value
  end


  def get_user(user)
    @hash['user:'+user]
  end

  def set_group(group, value)
    @hash['group:'+group]=value
  end


  def get_group(group)
    @hash['group:'+group]
  end


  def set_world(value)
    @hash['world']=value
  end

  def get_world
    @hash['world']
  end

  def delete_user(user)
    @hash['user:'+user] = nil
  end

  def delete_group(group)
    @hash['group:'+group] = nil
  end

end

