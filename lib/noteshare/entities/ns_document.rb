# An NSDocument consists of
#
#     * Various meta data such as title and author information
#     * Textual content, both in raw source and rendered form
#     * Structural links to subdocuments and associated documents
#
#   A master, or root document is one that is not a subdocuemnt
#   or associated document of any other document. It corresponds
#   to what we normally think of a document.  Subdocuments are
#   ordered and may themselves have subdocuments and associated
#   documents.  Consequently the subdocuments form a tree.  In the
#   simplest and most common case, the tree consists of just one
#   level and that subdocuments form the sections of the document.
#
#   Associated documents are not ordered and are entirely optional;
#   many documents have none.  Some examples.
#
#     * The sections of a document may have an "aside", or "sidebar".
#       All sections may have an aside, or some, or none.
#
#     * Sections may have one or more associated notes; these may
#       be intended for display, or to help the author during
#       composition of the document.
#
#     * Documents that use LaTeX may have a "texmacros" document
#
# An NSDocument is a complex object whose feeding and care requires
# the cooperation of many classes.  The NSDocument class is mostly
# concerned with various accessors and reporters: what is the root
# document of a given document, is it a root document, what is the
# 7th subdocument, etc. Other takss, such as adding subdocuments,
# rendering content, etc., are left to other classes.  This is so
# done in order to keep the size of classes within the bounds
# comprehensibility and to keep their focus on a single kind of
# work.
#
# Note that testing this class requires, for example, the XXX
# class, since it is there that the methods for building
# subdocuemnt structure are defined.




require_relative '../../ext/core'
# require_relative '../../../lib/noteshare/modules/tools'
require_relative '../../../lib/acl'  ### ???

# require_relative '../modules/toc_item'

# ^^^ audit dependencies

class NSDocument
  

  ###################################################
  #
  #     1. INITIALIZE AND CREATE
  #
  ###################################################

  require_relative '../modules/ns_document_setup'


  include Lotus::Entity
  attributes :id, :title, :identifier,
             :author_id, :author, :author_identifier, :author_credentials,
             :tags, :type, :area, :meta, :xattributes, :dict,
             :created_at, :updated_at,
             :content, :compiled_content, :rendered_content, :compiled_and_rendered_content, :render_options,
             :parent_ref, :root_ref, :parent_id, :index_in_parent, :root_document_id,
             :subdoc_refs, :toc, :doc_refs,
             :content_dirty, :compiled_dirty, :toc_dirty,
             :acl, :visibility, :groups_json,
             :author_credentials2


  # include Noteshare::Setup
  # include Noteshare::Tools
  include Noteshare
  # include Noteshare::Groups
  # include Noteshare::AsciidoctorHelper
  include ACL
  # include Noteshare::NSDocumentDictionary
  # include NSDocumentHelpers


  # When initializing an NSDocument, ensure that certain fields
  # have a standard non-nil value
  # The hash should follow this model
  #
  #  {title: 'Introduction to Chemistry', author_credentials{ id: 0, first_name: 'Linus', last_name: 'Pauling', identifier: 'abcd1234'}}


  def initialize(hash)

    hash.each { |name, value| instance_variable_set("@#{name}", value) }

    @subdoc_refs = [] if @subdoc_refs.nil?
    @toc ||= []
    @doc_refs = {} if @doc_refs.nil?
    @render_options ||= { 'format'=> 'adoc' }
    @root_document_id ||= 0
    @parent_id ||= 0
    @xattributes ||= []
    @dict ||= {}
    @acl ||= {}

    # @toc_dirty ||= true

  end

  # PUBLIC
  # Create a document given a hash.
  # The hash must define both the title and the author credentials,
  # as in the example below;
  #
  #   @author_credentials = { id: 0, first_name: 'Linus', last_name: 'Pauling', identifier: 'abcd1234'}
  #
  #   @article = NSDocument.create(title: 'A. Quantum Mechanics', author_credentials: @author_credentials)
  #
  # The hash may contain any other valid keys.
  #
  # NOTES: a document is recognized as a root document if its root_id
  # is zero.  If a document has no parent, its parent_id is nil
  # All documents begin life as root documents with no parent.
  #
  def self.create(hash)
    doc = NSDocument.new(hash)
    doc.title = hash[:title]
    doc.author_credentials2 = hash[:author_credentials]
    doc.identifier = Noteshare::Identifier.new().string
    doc.root_ref = { 'id'=> 0, 'title' => ''}
    if !(doc.content =~ /^== .*/)
      content = doc.content || ''
      content = "== #{doc.title}\n\n#{content}"
      doc.content = content
    end

    DocumentRepository.create doc
  end


  ###################################################
  #
  #     Deletion
  #     --------
  #     # delete
  #     # delete_subdocument
  #     # remove_from_parent
  #     ----------
  #     3
  #
  ###################################################


  # Docuemnts come in three kinds: root, subdocumnet,
  # and associated documennt
  def delete
    if is_associated_document?
      AssociateDocumentManager.new(self.parent_document).delete(self)
    else
      delete_subdocument
    end
  end

  # PRIVATE
  def delete_subdocument
    if parent_document
      self.remove_from_parent
    end
    DocumentRepository.delete self
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



  #########################################
  #
  #  References
  #  ----------
  #  parent_document
  #  grandparent_docuemnt
  #  root_document
  #  is_root_document?
  #  ancestor_ids
  #  next_oldest_ancestor
  #  subdocument
  #  first_section
  #  --------------
  #  7
  #
  #########################################N

  # *doc.parent* returns nil or the parent object
  def parent_document
    pi =  parent_item
    return if pi == nil
    pi_id = pi.id
    return if pi_id == nil
    DocumentRepository.find(pi_id)
  end

  # used by TOCManager
  def grandparent_document
    parent_document.parent_document
  end


  # The root_document is what you get by
  # following parent_document links to their
  # source. If the root_document_id is zero,
  # then the document is a root document.
  # Otherwise, the root_document_id is the
  # id of the root_documment.
  def root_document
    ri =  root_item
    return self if ri == nil # i.e, if it is a root document
    ri_id = ri.id
    return if ri_id == nil
    DocumentRepository.find(ri_id)
  end

  def is_root_document?
    self == find_root_document
  end

  def ancestor_ids
    cursor = self
    list = []
    while cursor.parent_document != nil
      list << cursor.parent_document.id
      cursor = cursor.parent_document
    end
    list
  end

  def next_oldest_ancestor
    noa = self
    return self if noa == root_document
    while noa.parent_document != root_document
      noa = noa.parent_document
    end
    noa
  end

  # *doc.subdocment(k)* returns the k-th
  # subdocument of *doc*
  def subdocument(k)
    # Fixme: bad code in next line
    # Think about who can modify toc
    toc_item = toc[k]
    if toc_item
      doc_id = toc_item[:id] || toc_item['id']
      DocumentRepository.find(doc_id) if doc_id
    end
  end


  def first_section
    subdocument(0)
  end


  # The level is the length of path from the root
  # to the give node (self)
  def level
    length = 0
    cursor = self
    while cursor.parent_document
      length += 1
      cursor = cursor.parent_document
    end
    length
  end

  # CORE METHOD, USED INTERNALLY AND IN TOC MANAGER
  # Return next NSDocument.  That is, if @foo, @bar, and @baz
  # are subocuments in order of @article, then @bar.next_document = @baz
  def next_document
    return if parent_document == nil
    _toc = TOC.new(parent_document)
    found_index = _toc.index_by_identifier(self.identifier)
    return if found_index == nil
    return if found_index > _toc.table.count - 2
    _id = _toc.table[found_index + 1].id
    return  DocumentRepository.find(_id)
  end


  # CORE METHOD, USED INTERNALLY AND IN TOC MANAGER
  # Return previous NSDocument.  That is, if @foo, @bar, and @baz
  # are subocuments in order of @article, then @bar.previous_document = @foo
  def previous_document
    return if parent_document == nil
    _toc = TOC.new(parent_document)
    found_index = _toc.index_by_identifier(self.identifier)
    return if found_index == nil
    return if found_index == 0
    _id = _toc.table[found_index - 1].id
    return  DocumentRepository.find(_id)
  end




  ###################################################
  #
  #      4. UPDATE CONTENT, COMPILE & RENDER
  #
  ###################################################

  # Used internally by compile_with_render,
  # export, and render
  # Used in controller titlepage

  # Used by ContentManager#compile
  #
  # *doc.compile* concatenates the contents
  # of *doc* with the compiled text of
  # each section of *doc*.  The sections
  # array is determined by #part, which is
  # a persistent array of integers which
  # represent the id's of the sections of
  # *doc*.
  def compile
    table = TOC.new(self).table
    if table == []
      return content || ''
    else
      text = content + "\n\n" || ''
      table.each do |item                                                                                                           |
        section = DocumentRepository.find(item.id)
        if section != nil
          text  << section.compile << "\n\n"
        end
      end
      return text
    end
  end


 ###################################


  # Apply a method with args to
  # a document, and all subdocuments
  # and associated documents
  def apply_to_tree(message, args)
    puts "#{self.title} #{message} #{args}"
    self.send(message, *args)
    DocumentRepository.update self
    table = TOC.new(self).table
    table.each do |item|
      doc = DocumentRepository.find item.id
      doc.apply_to_tree(message, args) if doc
    end
    doc_refs.each do |title, id|
      doc = DocumentRepository.find id
      doc.apply_to_tree(message, args) if doc
    end
  end


  ############################################################
  #
  #   URLS & LINKS
  #
  ############################################################


  # EXTENSIVE INTERNAL AND EXTERNAL USE
  # Return URL of document
  def url(prefix, stem)
    if prefix == ''
      "/#{stem}/#{self.id}"
    else
      "#{prefix}/#{stem}/#{self.id}"
    end
  end


  # INTERNAL AND EXTERNAL
  # Return html link to document
  def link(hash = {})
    title = hash[:title]
    prefix = hash[:prefix] || ''
    stem = hash[:stem] || 'document'
    if title
      "<a href=#{self.url(prefix, stem)}>#{title}</a>"
    else
      "<a href=#{self.url(prefix, stem)}>#{self.title}</a>"
    end
  end

  # USED BY APPS
  # Return link to the root document
  def root_link(hash = {})
    if self.type =~ /associated:/
      root_document.link(hash)
    else
      if root_document
        # hash[:view_mode] == 'compiled' ? '' :  root_document.link(hash)
        root_document.link(hash)
      else
        self.link(hash)
      end
    end
  end



  ########################
  #
  # ASSOCIATE DOCUMENTS
  #
  # about 13 lines of code
  #
  ########################


  # only in spec/
  # return hash of associates of a given document
  def associates
    self.doc_refs
  end


  # KEEP
  # @foo.associatd_document('summary')
  # retrieve the document associated to
  # @foo which is of type 'summary'
  def associated_document(type)
    DocumentRepository.find(self.doc_refs[type])
  end

  def is_associated_document?
    if type =~ /associated:/
      return true
    else
      return false
    end
  end



  #########################################


  # private

  def parent_item
    return if parent_ref == nil
    # TOCItem.new( parent_ref['id'], parent_ref['title'], parent_ref['identifier'], parent_ref['has_subdocs'] )
    # TOCItem.new( parent_ref[:id], parent_ref[:title], parent_ref[:identifier], parent_ref[:has_subdocs] )
    TOCItem.from_hash(parent_ref)
  end

  def root_item
    # return if root_ref == nil
    return if root_document_id == 0
    # TOCItem.new( root_ref['id'], root_ref['title'], root_ref['identifier'], root_ref['has_subdocs'] )
    #TOCItem.new( root_ref[:id], root_ref[:title], root_ref[:identifier], root_ref[:has_subdocs] )
    TOCItem.from_hash(root_ref)
  end

  def set_parent_document_to(parent)
    self.parent_id = parent.id
    self.parent_ref =  {"id"=>parent.id, "title"=>parent.title, "identifier"=>parent.identifier}
  end

  # Find the root document by finding
  # the parent of the parent of ...
  def find_root_document
    cursor = self
    while cursor.parent_document
      cursor = cursor.parent_document
    end
    cursor
  end

  def set_root_document_to(root)
    self.root_document_id = root.id
    self.root_ref = { id: root.id, title: root.title, identifier: root.identifier}
  end


end
