require_relative '../../ext/core'
require_relative '../../../lib/noteshare/modules/tools'
require_relative '../modules/toc_item'
require_relative '../../../lib/acl'
require_relative '../modules/groups'
require_relative '../../../lib/noteshare/modules/asciidoctor_helpers'
require_relative '../modules/document_dictionary'




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
  #     1. REQUIRE, INCLUDE, INITIALIZE AND DISPLAY
  #     2. MANAGE SUBDOCUMENTS
  #
  #
  ###################################################



  ###################################################
  #
  #     1. REQUIRE, INCLUDE, INITIALIZE AND DISPLAY
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
  # Display the fields of the reeiver
  # specified by arts.  'label' gives
  # the heading.
  #
  # Example: document.display('Test document', [:id, :title])
  def display(label, args)

    puts
    puts label.red
    args.each do |field|
      begin
        puts "#{field.to_s}: #{self.send(field)}"
      rescue
        puts "#{field.to_s}: ERROR".red
      end
    end
    puts

  end

  # PUBLIC
  # A convenience method for #display
  def self.info(id)
    doc = DocumentRepository.find(id)
    doc.display('Document', [:title, :identifier, :author_credentials2, :parent_ref, :root_ref, :render_options, :toc])
  end

  # PUBLIC
  def info
    self.display('Document', [:title, :identifier, :author, :author_id, :author_credentials2, :parent_id, :parent_ref, :root_document_id, :root_ref, :render_options, :toc, :dict])
  end


 # PUBLIC
 def rendered_content2
   if rendered_content and rendered_content != ''
     return rendered_content
   else
     return "<p style='margin:3em;font-size:24pt;'>This block of the document is blank.  Please edit it or go to the next block</p>"
   end

 end

  ############

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

  # PUBLIC: one uage in Permissions#grant
  # Return the author id from the author credentials
  def creator_id
    author_credentials2['id']
  end


  ### PRIVATE -- used ony in this class
  # Typical credential:
  #
  #  "id"=>91, "last_name"=>"Foo-Bar", g"first_name"=>"Jason", "identifier"=>"35e...48"
  #
  # Make all changes to author info via this method to keep data consistent
  def set_author_credentials(credentials)
    self.author_credentials2 =credentials
    first_name = credentials['first_name'] || ''
    last_name = credentials['last_name']  || ''
    author_id = credentials['id']
    self.author_id = author_id
    self.author = first_name + " " + last_name
  end

  # PUBLIC
  def  get_author_credentials
    self.author_credentials2
  end

  # PRIVATE
  def set_identifier
    self.identifier = Noteshare::Identifier.new().string
  end

  ## NOT USED
  def set_identifier!
    set_identifier
    DocumentRepository.update self
    self.identifier
  end

  # PRIVATE
  def set_author_identifier
    author_obj = UserRepository.find self.author_id
    if author_obj
      self.author_identifier = author_obj.identifier
    end
  end

  # NOT USED
  def set_author_identifier!
    set_author_identifier
    DocumentRepository.update self
    self.author_identifier
  end

  # PUBLIC
  # User for uniform interface to the
  # permissions class
  def creator_id
    author_id
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


  def is_associated_document?
    if type =~ /associated:/
      return true
    else
      return false
    end
  end


  #Fixme, spaghetti?
  # PUBLIC
  def delete
    if is_associated_document?
      AssociateDocManager.new(self).delete_associated_document
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

  # PRIVATE
  def grandparent_document
    parent_document.parent_document
  end


  # Return title, id, an ids of previous and next documents
  def status
    "#{self.title}:: id: #{self.id}, parent_document: #{self.parent.id }, back: #{self.doc_refs['previous']}, next: #{@self.doc_refs['next']}"
  end



  #########################################
  #
  #     SECTION??
  #
  #########################################N

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

  # ONLY IN TESTS
  def previous_toc_item
    table = TOC.new(parent_document).table
    index_of_previous_toc_item = index_in_parent - 1
    return table[index_of_previous_toc_item] if index_of_previous_toc_item > -1
  end

  # ONLY IN TESTS
  def next_toc_item
    return if parent_document == nil
    table = TOC.new(parent_document).table
    index_of_next_toc_item = index_in_parent + 1
    return table[index_of_next_toc_item] if index_of_next_toc_item < table.count
  end

  # NO USAGE
  def get_index_in_parent
    return if parent_document == nil
    table = TOC.new(parent_document).table
    table.each_with_index do |item, index|
      if self.identifier == item.identifier
        return index
      end
    end
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

  # ONLY IN TESTS
  def next_document_id
    doc = next_document
    doc.id if doc
  end

  # ONLY IN TESTS
  def previous_document_id
    doc = previous_document
    doc.id if doc
  end


  # NOT USED
  # Use the information in self.parent.subdoc_refs
  # to set the previous document link.  Thus,
  # if @foo and @bar are subdocuments in order
  # of @article, then after the call @bar.set_previous_doc,
  # @bar.previous_doc == @foo.
  def set_previous_doc
    self.doc_refs['previous'] = previous_id
    DocumentRepository.persist(self)
  end

  # Use the information in self.parent.subdoc_refs
  # to set the previous document link.  Thus,
  # if @foo and @bar are subdocuments in order
  # of @article, then after the call @foo.set_next_doc,
  # @foo.next_doc == @bar.
  def set_next_doc
    self.doc_refs['next'] = next_id
    DocumentRepository.persist(self)
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

  def set_parent_document_to(parent)
    self.parent_id = parent.id
    self.parent_ref =  {"id"=>parent.id, "title"=>parent.title, "identifier"=>parent.identifier}
  end


  def parent_title
    if parent_document
      parent_document.title
    else
      ''
    end
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


  # Find the root document by finding
  # the parent of the parent of ...
  def find_root_document
    cursor = self
    while cursor.parent_document
      cursor = cursor.parent_document
    end
    cursor
  end

  def ref
    TOCItem.new( self.id, self.title, self.identifier )
  end

  def set_root_document_to(root)
    self.root_document_id = root.id
    self.root_ref = { id: root.id, title: root.title, identifier: root.identifier}
  end

  def set_root_document_to_default
    rd = find_root_document
    # Need the follwing for DocumentRepository.root_documents
    # Fixme: index root_document_id
    if rd
      rd.root_document_id = 0
      self.root_document_id = rd.id
      self.root_ref = { id: rd.id, title: rd.title, identifier: rd.identifier}
    end
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
    _id = toc[k]['id']
    if _id
      DocumentRepository.find(_id)
    end
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
      table.each do |item|
        section = DocumentRepository.find(item.id)
        if section != nil
          text  << section.compile << "\n\n"
        end
      end
      return text
    end
  end

  def root_document_title
    root =  root_document || self
    if root
      root.title
    else
      ''
    end
  end

 ###################################

  def set_visibility(x)
    self.visibility = x
  end

  def set_author_id(x)
    self.author_id = x
  end

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

  def save
    puts "#{self.title}: #{self.acl}".red
    DocumentRepository.update self
    doc = DocumentRepository.find  self.id
    puts "#{doc.title}: #{doc.acl}".magenta
  end


  ############################################################
  #
  #   TITLES
  #
  ############################################################

  def parent_document_title
    p = parent_document
    p ? p.title : '-'
  end

  # PRIVATE, used in subdocument titles
  # Return previous document title or '-'
  def previous_document_title
    p = previous_document
    p ? p.title : '-'
  end

  # Return next document title or '-'
  def next_document_title
    p = next_document
    p ? p.title : '-'
  end


  # NOT USED
  # Return html text with links to the root and parent documents
  # as well as previous and next documents if they are present.
  def document_map
    str = "<strong>Map</strong>\n"
    str << "<ul>\n"
    str << "<li>Top: #{self.root_link}</li>\n"
    str << "<li>Up: #{self.parent_link}</li>\n"  if self.parent_document and self.parent_document != self.root_document
    str << "<li>Prev: #{self.previous_link}</li>\n"  if self.previous_document
    str << "<li>Next: #{self.next_link}</li>\n"  if self.next_document
    str << "</ul>\n\n"
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
        root_document.link(hash)
      else
        self.link(hash)
      end
    end
  end

  # INTERNAL: Document map only
  # HTML link to parent document
  def parent_link(hash = {})
    p = self.parent_document
    p ? p.link(hash) : ''
  end

  # INTERNAL: Document map only
  # HTML link to previous document
  # with arg1 = link text (or image)
  # if the link is valid and arg2
  # = link text (or image)
  # if the link is not valid
  def previous_link(hash = {})
    alt_title =  hash[:alt_title] || ''
    p = self.previous_document
    p ? p.link(hash) : alt_title
  end

  # INTERNAL: Document map only
  # HTML link to next document
  # with arg1 = link text (or image)
  # if the link is valid and arg2
  # = link text (or image)
  # if the link is not valid
  def next_link(hash = {})
    alt_title =  hash[:alt_title] || ''
    n = self.next_document
    n ? n.link(hash) : alt_title
  end

  # INTERNAL
  def associate_link(type, prefix='')
    if prefix == ''
      "<a href='/document/#{self.doc_refs[type]}'>#{type.capitalize}</a>"
    else
      "<a href='/#{prefix}/document/#{self.doc_refs[type]}'>#{type.capitalize}</a>"
    end

  end

  ##################################

  # NOT USED
  def author_screen_name
    _author = UserRepository.find author_id
    _author ? _author.screen_name  : '--'
  end

  ##################################


  # *doc.subdocument_titles* returns a list of the
  # titles of the sections of *document*.
  def subdocument_titles(option=:simple)
    #Fixme: bad implementation
    list = []
    if [:header].include? option
      list << self.title.upcase
    end
    toc = TOC.new(self)
    toc.table.each do |item|
      section = DocumentRepository.find(item.id)
      if [:header, :simple].include? option
        item = section.title
      elsif option == :verbose
        item = "#{section.id}, #{section.title}. back: #{section.previous_document_title}, forward: #{section.next_document_title}"
      end
      list << item
    end
    list
  end

end
