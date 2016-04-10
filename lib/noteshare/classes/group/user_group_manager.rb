

# The UserGroupManager is responsible for adding
# to a user, removing groups form a user,
# and adding, removing and changing group permissions
# for documents.
class UserGroupManager

  def initialize(user)
    @user = user
  end

  # produce an html lising of a user's groups
  def html_list
    output = "<ul>"
    @user.groups.sort.each do |group|
      output << "  <li>#{group}</li>\n"
    end
    output << "</ul>"
    output
  end

  # return a list of groups for the given docuemnt
  def groups_for_document(document)
    document.acl.keys.select{ |item| item =~ /\Agroup\:[a-zA-Z].*/ }.map { |item| item.sub('group:', '')}
  end

  # return a hash of the form
  # { 'group1': [document1, document2] 'group2': [documen1, documuent5] }
  def documents_for_groups
    user_documents = DocumentRepository.find_by_author_id(@user.id, :root_documents_only => 'yes')
    group_dictionary = {}
    user_documents.all.each do |doc|
      if doc.title
        groups = groups_for_document(doc)
        groups.each do |group|
          if group_dictionary[group] == nil
            group_dictionary[group] = [doc]
          else
            group_dictionary[group] << doc
          end
        end
      else
        DocumentRepository.delete doc
      end
    end
    group_dictionary
  end


  # produce an html lising of a user's groups and thei documents
  def html_list_with_documents
    documents = documents_for_group

    output = "<ul>"
    @user.groups.sort.each do |group|
      output << "  <li>#{group}</li>\n"
    end
    output << "</ul>"
    output
  end

  # produce reprsentations of a user's
  # groups in various formats
  def list(option=nil)
    case option
      when 'bare'
        @user.groups
      when :html
        html_list
      else
        @user.groups
    end
  end

  # Add a group to a user
  def add(group_name)
    @user.groups << group_name
    UserRepository.update @user
  end

  # Set the group permissions for a document.
  # If the acl field for the document does
  # not hava an entry for 'group:foo', then
  # that entry is added with the give permissions
  # IF the acl field exists, then the permissions
  # are updated.  For example,
  #
  #   #set(group_name: 'foo', document: @doc, permission: :rw)
  #
  # results in acl = {"group:foo"=>"rw"}
  def set(hash)
    group_name = hash[:group_name]
    document = hash[:document]
    permission = hash[:permission]
    case permission
      when :r
        document.acl_set(:group, group_name, 'r')
      when :rw
        document.acl_set(:group, group_name, 'rw')
      else
        document.acl_set(:group, group_name, '-')
    end
    UserRepository.update @user
  end

  # Delete the group from the user
  def delete(group_name)
    @user.groups.delete(group_name)
    UserRepository.update @user
  end


end