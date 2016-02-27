require_relative '../../ext/core'
require_relative '../../../lib/noteshare/modules/tools'
require_relative '../modules/toc_item'
require_relative '../../../lib/acl'
require_relative '../modules/groups'
require_relative '../../../lib/noteshare/modules/asciidoctor_helpers'
require_relative '../modules/document_dictionary'
require_relative '../modules/ns_document_helpers'


# require_relative '../modules/render'


# An instance of the Document class has *content*, a block of text,
# various metadata -- *title*, *author*, *tags* etc. -- and a set
# of links.  First, there is *subdoc_refs*, an array of *id's*
# of Documents.  The idea is that the text of document is composed of
# its content plus the content of it subdocuments. Subdocuments
# can have their own subdocuments, and so on. The *compile* method
# assembles the content of a document, its subdocuments, etc.,
# in the proper order.   Second, there is
# *doc_refs*, which is a hash that could look like this:
#
# { 'previous': 124, 'next': 201, 'comments': 444, 'summary': 555 }
#
# The *previous* and *next* keys are used by an editor for navigation.
# Keys like *comment* and *summary* point to little documents that
# may or may not not be compiled into the main text.  There is
# also a set of special pointers, *parent_id* and *index_in_parent*.
# Suppose that document 123 refers to document 555 via the  element
# of index two in its *subdoc_refs* array, e.g.,
#
#    subdoc_refs = [21, 19, 555, 56]
#
# Then the parent_id of document 555 is 123 and the value of
# index_in_parent is 2.
#
# The subdoc array is populated by the method *insert*.
# To illustrate, suppose we have documents @article,
# @section1, @section2, and @section3.  The succession of
# method calls
#
#    @section1.insert(0, @article)
#    @section2.insert(1, @article)
#    @section2.insert(2, @article)
#
# builds up the subdoc array of @article and manages
# the pointers parent_id, index_in_parent, previous
# and next.
#
#    CONTENTS
#
#       1. REQUIRE, INCLUDE, AND INITIALIZE
#
class NSDocument

  ###################################################
  #
  #     CONTENTS
  #
  #     1. Initialize and create
  #
  #        initialize
  #        create
  #
  #     2. Display
  #
  #
  #
  #
  #     2. MANAGE SUBDOCUMENTS
  #
  #
  ###################################################



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
             :created_at, :modified_at,
             :content, :compiled_content, :rendered_content, :compiled_and_rendered_content, :render_options,
             :parent_ref, :root_ref, :parent_id, :index_in_parent, :root_document_id,
             :subdoc_refs, :toc, :doc_refs,
             :content_dirty, :compiled_dirty, :toc_dirty,
             :acl, :visibility, :groups_json,
             :author_credentials2


  # include Noteshare::Setup
  include Noteshare::Tools
  include Noteshare
  include Noteshare::Groups
  include Noteshare::AsciidoctorHelper
  include ACL
  include Noteshare::NSDocumentDictionary
  include NSDocumentHelpers


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
  #     2. MANAGE SUBDOCUMENTS
  #
  ###################################################


  # USED INTERNALLY AND IN TESTS --  PRIVATE?
  # @section(k, @article) makes @section the k-th subdocument
  # of @article.  The subdocuments that were in position
  # k and above are shifted to the right.  This method
  # updates all links: parent, index_in_parent,
  # amd the relevant next and previous links                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  def insert(k, parent_document)

    # puts "Insert #{self.id} (#{self.title}) at k = #{k}"

    # Insert the TOCItem of the current document (receiver)
    # in the toc array of the parent document.
    # Note the index of the TOCItem and copy that index
    # into self.index_in_parent.  Thus, at the
    # the end of these operations, the parent
    # references the child (the subdocument),
    # and vice versa.
    parent_toc = TOC.new(parent_document)
    new_toc_item = TOCItem.new(self.id, self.title, self.identifier, false)
    parent_toc.insert(k, new_toc_item)
    parent_toc.save!
    self.index_in_parent =  k
    self.parent_ref = {id: parent_document.id, title: parent_document.title, identifier: parent_document.identifier, has_subdocs:true }
    self.parent_id = parent_document.id

    root_doc = find_root_document
    if root_doc
      self.root_document_id = root_doc.id
      self.root_ref = {id: root_doc.id, title: root_doc.title, identifier: root_doc.identifier, has_subdocs:true }
    else
      self.root_ref = {id: 0, title: '', identifier: '', has_subdocs:false }
    end

      # Inherit the render_option from the root document
    if root_doc and root_doc != self
      self.render_options = root_doc.render_options
    end

    # update index_in_parent for subdocuments
    # that were shifted to the right
    # puts "Shifting ..."
    # puts "parent_document.subdoc_refs.tail(k+1): #{parent_document.subdoc_refs.tail(k)}"
    TOC.new(parent_document).table.tail(k).each do |item|
      doc = DocumentRepository.find item.id
      doc.index_in_parent = doc.index_in_parent + 1
      DocumentRepository.update(doc )
    end

    DocumentRepository.update(self)
    DocumentRepository.update(parent_document)

    # update_neighbors

  end

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


  #########################################
  #
  #  References
  #
  #########################################N

  # used by TOCManager
  def grandparent_document
    parent_document.parent_document
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


  ##################
  # PARENT DOCUMENT
  ##################

  # *doc.parent* returns nil or the parent object
  def parent_document
    pi =  parent_item
    return if pi == nil
    pi_id = pi.id
    return if pi_id == nil
    DocumentRepository.find(pi_id)
  end


  ##################
  # ROOT DOCUMENT
  ##################

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

  ##################
  # ANCESTORS
  ##################

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
    doc_id = toc_item[:id] || toc_item['id']
    DocumentRepository.find(doc_id) if doc_id
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
  # about 80 lines of code
  #
  ########################


  # return hash of associates of a given document
  def associates
    self.doc_refs
  end

  # @foo.associate_to(@bar, 'summary',)
  # associates @foo to @bar as a 'summary'.
  # It can be retrieved as @foo.associated_document('summary')
  def associate_to(parent, type)
    parent.doc_refs[type] = self.id
    self.type = 'associated:' + type
    self.set_parent_document_to(parent)
    self.set_root_document_to(parent)
    DocumentRepository.update(parent)
    DocumentRepository.update(self)
  end


  # Add associate to receiver
  # Example
  #
  #    @content = 'Dr. Smith said that conservation laws ...'
  #    @article.add_associate(title: 'Notes from class', type: 'note', content: @content)
  #
  def add_associate(hash)

    type = hash.delete(:type)

    doc = NSDocument.new(hash)
    doc.identifier = Noteshare::Identifier.new().string
    doc.root_ref = { 'id'=> 0, 'title' => ''}
    doc.author_id = self.author_id
    doc.author = self.author
    doc.author_credentials2 = self.author_credentials2

    doc2 = DocumentRepository.create doc

    doc2.associate_to(self, type)

    doc2

  end

  # The method below assumes that a document
  # is the associate of at most one other
  # document.  This should be enforced (#fixme)
  def disassociate
    _parent = parent_document
    _type = self.type.sub('associated:', '')
    _parent.doc_refs.delete(_type)
    self.parent_id = 0
    self.parent_ref =  nil
    self.root_document_id = 0
    self.root_ref = nil
    DocumentRepository.update(_parent)
    DocumentRepository.update(self)
  end


  # @foo.associatd_document('summary')
  # retrieve the document associated to
  # @foo which is of type 'summary'
  def associated_document(type)
    DocumentRepository.find(self.doc_refs[type])
  end


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

  def is_associated_document?
    if type =~ /associated:/
      return true
    else
      return false
    end
  end

  def delete_associated_document
    disassociate
    DocumentRepository.delete self
  end



end
