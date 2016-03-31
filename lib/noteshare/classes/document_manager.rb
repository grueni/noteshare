


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


  # PUBLIC
  def add_as_sibling(hash)
    new_sibling = hash[:new_sibling]
    old_sibling = hash[:old_sibling]
    direction =  hash[:direction]
    toc = TOC.new(@parent_document)
    position = toc.index_by_identifier(old_sibling.identifier)
    direction == :before ? offset = 0 : offset = +1
    position = position + offset
    return if position < 0
    return if position > toc.count
    insert(subdocument: new_sibling, position: position)
  end


  # PUBLIC
  # section.add_to(article) makes section
  # the last subdocument of article
  def append(new_document)
    new_index = @parent_document.toc.length
    insert(subdocument: new_document, position: new_index)
  end

  def remove(subdocument)
    toc = TOC.new(@parent_document)
    toc.delete_by_identifier(subdocument.identifier)
    toc.save!
  end

  def delete(subdocument)
    remove(subdocument)
    DocumentRepository.delete subdocument
  end

  def move(subdocument, new_position)
    remove(subdocument)
    insert(subdocument: subdocument, position: new_position)
  end

end


