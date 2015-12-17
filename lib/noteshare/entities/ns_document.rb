require_relative '../../ext/core'
require_relative '../../../lib/noteshare/modules/tools'
require_relative '../modules/toc_item'
require_relative '../../../lib/acl'
require_relative '../modules/groups'
require_relative '../../../lib/noteshare/modules/asciidoctor_helpers'




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
  #     3. ASSOCIATED DOCUMENTS
  #     4. UPDATE, COMPILE & RENDER
  #     5. TABLE OF CONTENTS
  #
  ###################################################



  ###################################################
  #
  #     1. REQUIRE, INCLUDE, INITIALIZE AND DISPLAY
  #
  ###################################################

  require_relative '../modules/ns_document_setup'


  include Lotus::Entity
  attributes :id, :author_id, :author, :author_identifier, :author_credentials, :title, :identifier, :tags, :type, :area, :meta,
    :created_at, :modified_at, :content, :compiled_content, :rendered_content, :compiled_and_rendered_content, :render_options,
    :parent_ref, :root_ref, :parent_id, :index_in_parent, :root_document_id, :visibility,
    :subdoc_refs,  :toc, :doc_refs, :content_dirty, :compiled_dirty, :toc_dirty, :acl, :groups_json


  # include Noteshare::Setup
  include Noteshare::Tools
  include Noteshare
  include Noteshare::Groups
  include Noteshare::AsciidoctorHelper


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

    # @toc_dirty ||= true

  end

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

  # A convencience method for #display
  def self.info(id)
    doc = DocumentRepository.find(id)
    doc.display('Document', [:title, :identifier, :author_credentials, :parent_ref, :root_ref, :render_options, :toc])
  end

  def info
    self.display('Document', [:title, :identifier, :author, :author_id, :author_credentials, :parent_id, :parent_ref, :root_document_id, :root_ref, :render_options, :toc])
  end

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
    doc.set_author_credentials(hash[:author_credentials])
    doc.identifier = Noteshare::Identifier.new().string
    doc.root_ref = { 'id'=> 0, 'title' => ''}
    if !(doc.content =~ /^== .*/)
      content = doc.content || ''
      content = "== #{doc.title}\n\n#{content}"
      doc.content = content
    end

    DocumentRepository.create doc
  end


  # Return the author id from the author credentials
  def creator_id
    get_author_credentials.id
  end


  # Typical credential:
  #
  #  "id"=>91, "last_name"=>"Foo-Bar", "first_name"=>"Jason", "identifier"=>"35e...48"}
  #
  # Make all changes to author info via this method to keep data consistent
  def set_author_credentials(credentials)
    self.author_credentials = JSON.generate(credentials)
    first_name = credentials[:first_name]
    last_name = credentials[:last_name]
    author_id = credentials[:id]
    self.author_id = author_id
    self.author = first_name + " " + last_name
  end

  def get_author_credentials
    JSON.parse(self.author_credentials)
  end

  def set_identifier
    self.identifier = Noteshare::Identifier.new().string
  end

  def set_identifier!
    set_identifier
    DocumentRepository.update self
    self.identifier
  end

  def set_author_identifier
    author_obj = UserRepository.find self.author_id
    if author_obj
      self.author_identifier = author_obj.identifier
    end
  end

  def set_author_identifier!
    set_author_identifier
    DocumentRepository.update self
    self.author_identifier
  end

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

  # Used by #insert to preserve the
  # validity of the previous and next
  # links of subdocuments.
  def update_neighbors
    self.set_previous_doc
    self.set_next_doc

    if previous_document
      previous_document.set_next_doc
    end

    if next_document
      next_document.set_previous_doc
    end
  end


  # section.add_to(article) makes section
  # the last subdocument of article
  def add_to(parent_document)
    new_index = parent_document.toc.length
    insert(new_index, parent_document)
  end

  def delete_subdocument
    if parent_document
      self.remove_from_parent
    end
    DocumentRepository.delete self
  end

  def delete_associated_document
    disassociate
    DocumentRepository.delete self
  end

  def delete
    if is_associated_document?
      delete_associated_document
    else
      delete_subdocument
    end
  end

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


  # @foo.move_to(7) moves @foo in its
  # parent document to position 7.
  # Subdocuments that were in position 7 and up
  # are moved up.
  def move_to(new_position)
    remove_from_parent
    insert(new_position, parent_document)
  end

  def grandparent_document
    parent_document.parent_document
  end

  def move_leve_up
    gp = grandparent_document
    if gp != parent_document
      remove_from_parent
      add_to(gp)
      return gp
    else
      puts 'grand parent iS parent'.cyan
      return parent_document
    end
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

  def previous_toc_item
    table = TOC.new(parent_document).table
    index_of_previous_toc_item = index_in_parent - 1
    return table[index_of_previous_toc_item] if index_of_previous_toc_item > -1
  end

  def next_toc_item
    return if parent_document == nil
    table = TOC.new(parent_document).table
    index_of_next_toc_item = index_in_parent + 1
    return table[index_of_next_toc_item] if index_of_next_toc_item < table.count
  end

  def get_index_in_parent
    return if parent_document == nil
    table = TOC.new(parent_document).table
    table.each_with_index do |item, index|
      if self.identifier == item.identifier
        return index
      end
    end
  end

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

  def next_document_id
    doc = next_document
    doc.id if doc
  end

  def previous_document_id
    doc = previous_document
    doc.id if doc
  end

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
    _id = table_of_contents[k].id
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
  #      3. ASSOCIATED DOCUMENTS
  #
  ###################################################

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

  # return hash of associates of a given document
  def associates
    self.doc_refs
  end

  def is_associated_document?
    if type =~ /associated:/
      return true
    else
      return false
    end
  end

  ###################################################
  #
  #      4. UPDATE CONTENT, COMPILE & RENDER
  #
  ###################################################


  def update_content_from(str)
    tm = texmacros || ''
    renderer = Render.new(tm + str)
    self.rendered_content = renderer.convert
  end

  # If input is nil, render the content
  # and save it in rendered_content.  Otherwise,
  # Replace #content by str, render it
  # and save itl. .
  def update_content(input=nil)

    # dirty = self.content_dirty
    # dirty = true if dirty.nil?
    # return if dirty == false

    if input == nil
      str = self.content || ''
    else
      str = input
      self.content = str
    end

    render_by_identity = dict_lookup('render') == 'identity'
    if render_by_identity
      self.rendered_content =  content
    else
      update_content_from(str)
    end

    self.content_dirty = false
    DocumentRepository.update self

  end

  def texmacros
    rd = root_document || self
    if rd and rd.doc_refs['texmacros']
      macro_text = rd.associated_document('texmacros').content
      macro_text = macro_text.gsub(/^=*= .*$/,'')
      macro_text = "\n\n[env.texmacro]\n--\n#{macro_text}\n--\n\n"
      macro_text
    end
  end

  # *doc.compile* concatenates the contents
  # of *doc* with the compiled text of
  # each section of *doc*.  The sections
  # array is determined by #part, which is
  # a persistent array of integers which
  # represent the id's of the sections of
  # *doc*.
  def compile_aux
    table = table_of_contents
    if table == []
      return content || ''
    else
      text = content + "\n\n" || ''
      table.each do |item|
        section = DocumentRepository.find(item.id)
          if section != nil
          text  << section.compile_aux << "\n\n"
        end
      end
      return text
    end
  end

  def compile
    tm = texmacros  || ''
    result = tm + compile_aux
    result
  end


  def render_lazily
    if content_dirty
      render
    end
  end


  # NSDocument#render is the sole connection between class NSDocument and
  # module Render.  It updates self.rendered_content by applying
  # Asciidoctor.convert to self.content with the provided options.
  def render

    format = @render_options['format']

    case format
      when 'adoc'
        render_option = {}
      when 'adoc-latex'
        render_option = {backend: 'html5'}
      else
        render_option = {}
    end

    renderer = Render.new(self.compile, render_option )
    self.rendered_content = renderer.convert
    self.content_dirty = false
    DocumentRepository.update(self)

  end


  def compile_with_render_lazily(option={})
    if compiled_dirty
      compile_with_render(option)
    end
  end


  def get_render_option
    format = self.render_options['format']

    case format
      when 'adoc'
        render_option = {}
      when 'adoc-latex'
        render_option = {backend: 'html5'}
      else
        render_option = {}
    end

  end

  # Compile the receiver, render it, and store the
  # rendered text in self.compiled_and_rendered_content
  def compile_with_render(option={})
    start = Time.now

    renderer = Render.new(self.compile, get_render_option )
    self.compiled_and_rendered_content = renderer.convert
    self.compiled_dirty = false
    value = DocumentRepository.update(self)

    finish = Time.now
    elapsed = finish - start
    return value
  end

  def export
    header = '= ' << title << "\n"
    header << author << "\n"
    header << ":numbered:" << "\n"
    header << ":toc2:" << "\n\n\n"

    renderer = Render.new(header + texmacros + self.compile, get_render_option )
    renderer.rewrite_urls
    file_name = self.title.normalize
    path = "outgoing/#{file_name}.adoc"
    IO.write(path, renderer.source)
    export_html(get_render_option)

  end

  def export_html(format)

    file_name = self.title.normalize
    path = "outgoing/#{file_name}.adoc"
    format = self.render_options['format']

    case format
      when 'adoc'
        cmd = "asciidoctor #{path}"
      when 'adoc-latex'
        cmd = "asciidoctor-latex -b html #{path}"
      else
        cmd =  "asciidoctor #{path}"
    end

    system cmd

  end


  #########################################################
  #
  #  TABLE OF CONTENTS
  #
  #########################################################

  # Return TOC object corresponding to the toc
  # field in the database
  def table_of_contents
    TOC.new(self).table
  end


  def set_toc_dirty
    self.toc_dirty = true
    self.root_document.toc_dirty = true
  end

  def set_toc_clean
    self.toc_dirty = false
    self.root_document.toc_dirty = false
  end

  def toc_is_dirty
    self.root_document.toc_dirty
  end

  # return the TOC item with given id
  def toc_item(id)
    target = nil
    self.toc.each do |item|
      if item[:id] == id
        target = item
        break
      end
    end
    target
  end

  # return the TOC item with given id
  def toc_item_change_title(id, new_title)
    target = nil
    self.toc.each do |item|
      if item[:id] == id
        item[:title] = new_title
        target = item
        break
      end
    end
    target
  end


  # A table of contents is an array of hashes,
  # where the key-value pairs are like
  #
  #    hash['id'] = 23
  #    hash['title'] = 'Long Journey'
  #    hash['subdocs'] = true
  #
  # The metnod  #update_table_of_contents
  # creates this structure from scratch, then stores
  # it as jsonb in the toc field of the database
  def update_table_of_contents(arg = {force: false})

  end

  def update_toc_at_root
    root_document.update_table_of_contents
  end


  ###############



  ############################################################
  #
  #   TABLE OF CONTENTS & MAP
  #
  ############################################################

  def permute_table_of_contents(permutation)
    toc2 = self.toc.permute(permutation)
    self.toc = toc2
    DocumentRepository.update self
  end

  # Return a string representing the table of
  # contents.  The format of the string can
  # be modified by the choice of the option
  # passed to the method.  The default 'simple_string'
  # option gives a numbered list of titles.
  def table_of_contents_as_string(hash)
    option = hash[:format] || 'simple_string'
    current_document = hash[:current_document]
    if current_document
      noa = current_document.next_oldest_ancestor
      noa_id = noa.id if noa
    end
    output = ''
    case option
      when 'simple_string'
        toc.each_with_index do |item, index|
          output << "#{index + 1}. #{item['title']}" << "\n"
        end
      when 'html'
        if toc.length == 0
          output = ''
        else
          output << "<ul>\n"
          toc.each_with_index do |item, index|
            output << "<li><a href='/document/#{item['id']}'>#{item['title']}</a>\n"
            if noa_id and item['id'] == noa_id
              output << "<ul>\n" << noa.table_of_contents_as_string(format: 'html', current_document: nil) << "</ul>"
            end
          end
          output << "</ul>\n\n"
        end
      else
        output = toc.to_s
    end
    output
  end

  def root_document_title
    root = root_document || self
    if root
      root.title
    else
      ''
    end
  end

  # The active_id is the id of the subdocument which
  # the user has selected.
  def root_table_of_contents(active_id, target='reader')
    root = root_document || self
    if root
      root.master_table_of_contents(active_id, target)
    else
      ''
    end
  end



  def process_toc_item(item, active_id, ancestral_ids, target)

    doc_id = item.id
    doc_title = item.title

    target == 'editor' ? prefix = '/editor' : prefix = ''
    doc_link = "href='#{prefix}/document/#{doc_id}'>#{doc_title}</a>"

    class_str = "class = '"

    if item.has_subdocs  # has_subdocs is field of the struct item
      (ancestral_ids.include? item.id) ? class_str << 'subdocs-open ' : class_str << 'subdocs-yes '
    else
      class_str << 'subdocs-no '
    end

    doc_id == active_id ? class_str << 'active' : class_str << 'inactive'

    "<li #{class_str} '><a #{doc_link}</a>\n"

  end


  def dive(item, active_id,  ancestral_ids, target, output)

    attributes = ['skip_first_item', 'auto_level']
    item.id == active_id ?   attributes << 'internal' : attributes << 'external'
    attributes << 'inert' if target == 'editor'

    doc = DocumentRepository.find item.id
    return '' if doc == nil

    output << doc.internal_table_of_contents(attributes, {doc_id: doc.id} )
    # Fixme: memoize, make lazy what we can.

    # Here is where the recursion happens:
    if doc.table_of_contents.length > 0 and ancestral_ids.include? doc.id
      output << "<ul>\n" << doc.master_table_of_contents(active_id, target) << "</ul>"
    end

    output
  end

  # If active_id matches the id of an item
  # in the table of contents, that item is
  # marked with the css 'active'.  Otherwise
  # it is marked 'inactive'.  This way the
  # TOC entry for the document being currently
  # viewed can be highlighted.``
  #
  def master_table_of_contents(active_id, target='reader')

    start = Time.now

    if toc.length == 0
      return ''
    end

    if active_id > 0
      active_document = DocumentRepository.find(active_id)
    else
      active_document = nil
    end

    if active_document
      ancestral_ids = active_document.ancestor_ids << active_document.id
    else
      ancestral_ids = []
    end

    target == 'editor'? output = "<ul class='toc2'>\n" : output = "<ul class='toc2'>\n"

    self.table_of_contents.each do |item|

      output << process_toc_item(item, active_id, ancestral_ids, target)
      dive(item, active_id,  ancestral_ids, target, output)

    end

    finish = Time.now
    elapsed = finish - start

    output << "</ul>\n\n"

  end


  def internal_table_of_contents(attributes, options)

    start = Time.now

    (attributes.include? 'root') ? source = self.compiled_content : source = self.content

    toc =  Noteshare::AsciidoctorHelper::NSTableOfContents.new(source, attributes, options)

    result = toc.table || ''

    finish = Time.now
    elapsed = finish - start

   return result

  end


  ##################################

  def dict_set(new_dict)
    if meta
      metadata = JSON.parse self.meta
    else
      metadata = {}
    end
    metadata['dict'] = new_dict
    self.meta = JSON.generate metadata
    DocumentRepository.update self
    new_dict
  end


  # Example: @foo.dict_update 'children': 5
  def dict_update(entry)
    metadata = JSON.parse self.meta
    dict = metadata['dict'] || { }
    dict[entry.keys[0]] = entry.values[0]
    metadata['dict'] = dict
    self.meta = JSON.generate metadata
    DocumentRepository.update self
    entry
  end

  def dict_lookup(key)
    return nil if meta == nil
    metadata = JSON.parse self.meta
    dict = metadata['dict'] || { }
    dict[key]
  end

  def dict_list
    if meta == nil
      puts 'empty'
      return ''
    end
    metadata = JSON.parse self.meta
    dict = metadata['dict'] || { }
    dict.each do |key, value|
      puts "#{key} => #{value}"
    end
  end

  def dict_delete(key)
    metadata = JSON.parse self.meta
    dict = metadata['dict'] || { }
    dict[key] = nil
    metadata['dict'] = dict
    self.meta = JSON.generate metadata
    DocumentRepository.update self
    key
  end

  def dict_clear
    metadata = JSON.parse self.meta
    metadata['dict'] = {}
    self.meta = JSON.generate metadata
    DocumentRepository.update self
    key
  end


  ###########  ACL  ##########

  def set_acl(acl)
    self.acl = acl.to_json
    DocumentRepository.update self
  end


  def set_acl!(acl)
    self.set_acl(acl)
    DocumentRepository.update self
  end

  def get_acl
    ACL.parse(self.acl)
  end

  def get_user_permission(user='')
    get_acl.get_user(user)
  end

  def get_group_permission(group='')
    get_acl.get_group(group)
  end

  def get_world_permission
    get_acl.get_world
  end

  def set_permissions(u, g, w)
    a = ACL.create_with_permissions(u, g, w)
    self.acl =  a.to_json
    DocumentRepository.update self
  end



  ###################################


  def set_visibility(x)
    self.visibility = x
  end

  # Apply a method with args to
  # a document, and all subdocuments
  # and associated documents
  def apply_to_tree(message, args)
    self.send(message, *args)
    DocumentRepository.update self
    table = TOC.new(self).table
    table.each do |item|
      doc = DocumentRepository.find item.id
      doc.apply_to_tree(message, args)
    end
    doc_refs.each do |title, id|
      doc = DocumentRepository.find id
      doc.apply_to_tree(message, args)
    end
  end

  # Apply a method with args to
  # a document, and all subdocuments
  # and associated documents
  def apply_to_tree1(message, args)
    self.send(message, *args)
    table = TOC.new(self).table
    table.each do |item|
      doc = DocumentRepository.find item.id
      doc.send(message, *args)
      DocumentRepository.update doc
    end
    doc_refs.each do |title, id|
      doc = DocumentRepository.find id
      doc.send(message, *args)
      DocumentRepository.update doc
    end
  end

  # Reload object from database
  def reload
    DocumentRepository.find  self.id
  end





  ################

  ############################################################
  #
  #   TITLES
  #
  ############################################################

  def parent_document_title
    p = parent_document
    p ? p.title : '-'
  end

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





  ############################################################
  #
  #   ASSOCIATED DOCUMENTS
  #
  ############################################################

  def root_associated_document_map(target='reader')
    root = root_document || self
    root.associated_document_map(target)
  end

  # Remove stale keys
  # Fixme: this will become obsolete
  # when things are working better
  def heal_associated_docs
    bad_keys = []
    self.doc_refs do |key, value|
      if DocumentRepository.find key == nil
        bad_keys << key
      end
    end
    bad_keys.each do |key|
      self.doc_refs.delete(key)
    end
    DocumentRepository.update self
  end

  def associated_document_map(target='reader')

    heal_associated_docs

    if self.type =~ /associated:/
      document = self.parent_document
    else
      document = self
    end

    hash = document.doc_refs
    keys = hash.keys
    if keys
      keys.delete "previous"
      keys.delete "next"
      map = "<ul>\n"
      keys.sort.each do |key|
        if target == 'editor'
          map << "<li>" << "#{self.associate_link(key, 'editor')}</li>\n"
        else
          map << "<li>" << "#{self.associate_link(key)}</li>\n"
        end
      end
      map << "</ul>\n"
    else
      map = ''
    end
    map
  end



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

  # Return URL of document
  def url(prefix='')
    if prefix == ''
      #"http:/document/#{self.id}"
      "/document/#{self.id}"
    else
      #"http://#{prefix}/document/#{self.id}"
      "#{prefix}/document/#{self.id}"
    end

  end

  # Return html link to document
  def link(hash = {})
    title = hash[:title]
    prefix = hash[:prefix] || ''
    if title
      "<a href=#{self.url(prefix)}>#{title}</a>"
    else
      "<a href=#{self.url(prefix)}>#{self.title}</a>"
    end
  end

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

  # HTML link to parent document
  def parent_link(hash = {})
    p = self.parent_document
    p ? p.link(hash) : ''
  end

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


  def associate_link(type, prefix='')
    if prefix == ''
      "<a href='/document/#{self.doc_refs[type]}'>#{type.capitalize}</a>"
    else
      "<a href='/#{prefix}/document/#{self.doc_refs[type]}'>#{type.capitalize}</a>"
    end

  end

  ##################################

  private
  # Assume that receiver is subdocument k of parent_document.
  # Return the id of subdocument k - 1 or nil
  def previous_id
    p = parent_document
    return nil if p == nil
    return nil if index_in_parent == nil
    return nil if index_in_parent-1 < 0
    table = TOC.new(p).table
    return table[index_in_parent-1].id
  end

  # Assume that receiver is subdocument k of parent.
  # Return the id of subdocuemnt k + 1 or nil
  def next_id
    p = parent_document
    return nil if p == nil
    return nil if index_in_parent == nil
    return nil if index_in_parent+1 > p.subdoc_refs.length
    table = TOC.new(p).table

    return toc[index_in_parent+1].id
  end


end
