


# The DocumentManager class
# is responsible for adding
# and deleting documents
# attached to a Master Document
class DocumentManager

  def initialize(parent_document)
    @parent_document = parent_document
  end


  # USED INTERNALLY AND IN TESTS --  PRIVATE?
  # @section(k, @article) makes @section the k-th subdocument
  # of @article.  The subdocuments that were in position
  # k and above are shifted to the right.  This method
  # updates all links: parent, index_in_parent,
  # amd the relevant next and previous links
  def insert(hash)

    subdocument = hash[:subdocument]
    position = hash[:position]

    # puts "Insert #{self.id} (#{self.title}) at k = #{k}"

    # Insert the TOCItem of the current document (receiver)
    # in the toc array of the parent document.
    # Note the index of the TOCItem and copy that index
    # into self.index_in_parent.  Thus, at the
    # the end of these operations, the parent
    # references the child (the subdocument),
    # and vice versa.
    parent_toc = TOC.new(@parent_document)
    new_toc_item = TOCItem.new(subdocument.id, subdocument.title, subdocument.identifier, false)
    parent_toc.insert(position, new_toc_item)
    parent_toc.save!
    subdocument.index_in_parent =  position
    subdocument.parent_ref = {id: @parent_document.id, title: @parent_document.title, identifier: @parent_document.identifier, has_subdocs:true }
    subdocument.parent_id = @parent_document.id

    root_doc = @parent_document.find_root_document
    if root_doc
      subdocument.root_document_id = root_doc.id
      subdocument.root_ref = {id: root_doc.id, title: root_doc.title, identifier: root_doc.identifier, has_subdocs:true }
    else
      subdocument.root_ref = {id: 0, title: '', identifier: '', has_subdocs:false }
    end

    # Inherit the render_option from the root document
    if root_doc and root_doc != subdocument
      subdocument.render_options = root_doc.render_options
    end

    # update index_in_parent for subdocuments
    # that were shifted to the right
    # puts "Shifting ..."
    # puts "parent_document.subdoc_refs.tail(k+1): #{parent_document.subdoc_refs.tail(k)}"
    TOC.new(@parent_document).table.tail(position).each do |item|
      doc = DocumentRepository.find item.id
      doc.index_in_parent = doc.index_in_parent + 1
      DocumentRepository.update(doc )
    end

    DocumentRepository.update(subdocument)
    DocumentRepository.update(@parent_document)

    # update_neighbors

  end


=begin

  # PUBLIC
  def add_as_sibling_of(document, direction)
    p = document.parent_document
    _toc = TOC.new(p)
    k = _toc.index_by_identifier(document.identifier)
    direction == :before ? offset = 0 : offset = +1
    k = k + offset
    return if k < 0
    return if k > _toc.count
    insert(k,p)
  end


  # PUBLIC
  # section.add_to(article) makes section
  # the last subdocument of article
  def add_to(parent_document)
    new_index = parent_document.toc.length
    insert(new_index, parent_document)
  end

  # PRIVATE
  def delete_subdocument
    if parent_document
      self.remove_from_parent
    end
    DocumentRepository.delete self
  end



  #Fixme, spaghetti?
  # PUBLIC
  def delete
    if is_associated_document?
      puts "I am now in DELETE!".red
      delete_associated_document
    else
      delete_subdocument
    end
  end


  # PRIVATE, tests
  # @foo.remove_from_parent removes
  # @foo as a subdocument of its parent.
  # It does not delete @foo.
  # Fixme: it is intended that a document have at most one parent.
  # However, this is not yet enforced.
  def remove_from_parent
    p = parent_document
    _toc = TOC.new(p)
    _toc.delete_by_identifier(self.identifier)
    _toc.save!
  end



  # NOT UESD EXCEPT IN TESTS
  # @foo.move_to(7) moves @foo in its
  # parent document to position 7.
  # Subdocuments that were in position 7 and up
  # are moved up.
  def move_to(new_position)
    remove_from_parent
    insert(new_position, parent_document)
  end

=end

end