require_relative '../../ext/core'
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
#    @section2.insert(2, @artcile)
#
# builds up the subdoc array of @article and manages
# the pointers parent_id, index_in_parent, previous
# and next.
class NSDocument
  include Lotus::Entity
  attributes :id, :author, :title, :tags, :type, :area, :meta,
    :created_at, :modified_at, :content, :rendered_content, :compiled_and_rendered_content, :render_options,
    :parent_id, :author_id, :index_in_parent, :root_document_id, :visibility,
    :subdoc_refs,  :doc_refs, :toc

  require_relative 'ns_document_presentation'
  include NSDocument::Presentation

  require_relative 'ns_document_setup'
  include NSDocument::Setup


  # When initializing an NSDocument, ensure that certain fields
  # have a standard non-nil value
  def initialize(hash)
    hash.each { |name, value| instance_variable_set("@#{name}", value) }
    @subdoc_refs = [] if @subdoc_refs.nil?
    @doc_refs = {} if @doc_refs.nil?
    @root_document_id ||= 0
    @render_options ||= { 'format'=> 'adoc' }
    @toc ||= []
  end

  # @section(k, @article) makes @section the k-th subdocument
  # of @article.  The subdocuments that were in position
  # k and above are shifted to the right.  This method
  # updates all links: parent, index_in_parent,
  # amd the relevant next and previous links
  def insert(k, parent_document)

    # puts "Insert #{self.id} (#{self.title}) at k = #{k}"

    index = parent_document.subdoc_refs || []
    index.insert(k, self.id)
    parent_document.subdoc_refs = index
    self.index_in_parent =  k
    self.parent_id = parent_document.id
    if parent_document.root_document_id == 0
      self.root_document_id = parent_document.id
    else
      self.root_document_id = parent_document.root_document_id
    end


    # update index_in_parent for subdocuments
    # that were shifted to the right
    # puts "Shifting ..."
    # puts "parent_document.subdoc_refs.tail(k+1): #{parent_document.subdoc_refs.tail(k)}"
    parent_document.subdoc_refs.tail(k).each do |id|
      doc = DocumentRepository.find id
      doc.index_in_parent = doc.index_in_parent + 1
      DocumentRepository.persist(doc )
    end

    DocumentRepository.persist(self)
    DocumentRepository.persist(parent_document)

    update_neighbors

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


  # @section.add_to(@article) makes @section
  # the last subdocument of @article
  def add_to(parent_document)
    n = parent_document.subdoc_refs.length
    insert(n, parent_document)
  end

  # @foo.associate('summary', @bar)
  # associats @foo to @bar as a 'summary'.
  # It can be retrieved as @foo.associatd_document('summary')
  def associate_as(type, doc)
    doc.doc_refs[type] = self.id
    self.parent_id = doc.id
    self.root_document_id = doc.id
    DocumentRepository.update(doc)
  end

  # @foo.associatd_document('summary')
  # retrieve the document associated to
  # @foo which is of type 'summary'
  def associated_document(type)
    DocumentRepository.find(self.doc_refs[type])
  end


  # @foo.remove_from_parent removes
  # @foo as a subdocument of its parent.
  # It oes not delete @foo.
  # Fixme: it is intended tht a document have at most one parent.
  # However, this is not yet enforced.
  def remove_from_parent
    k = index_in_parent
    p = parent
    pd = previous_document
    nd_id = next_document.id
    p.subdoc_refs.delete_at(k)
    DocumentRepository.persist(p)

    # update index_in_parent for subdocuments
    # that were shifted to the left
    # puts "Shifting ..."
    # puts "parent_document.subdoc_refs.tail(k+1): #{parent_document.subdoc_refs.tail(k)}"
    p.subdoc_refs.tail(k-1).each do |id|
      doc = DocumentRepository.find id
      doc.index_in_parent = doc.index_in_parent - 1
      DocumentRepository.persist(doc )
    end

    if pd
      pd.set_next_doc
    end

    nd =  DocumentRepository.find nd_id
    if nd
      nd.set_previous_doc
    end
  end

  # @foo.move_to(7) moves @foo in its
  # parent document to position 7.
  # Subdocuments that were in position 7 and up
  # are moved up.
  def move_to(new_position)
    remove_from_parent
    insert(new_position, parent)
  end

  # Assume that receiver is subdocument k of parent.
  # Return the id of subdocument k - 1 or nil
  def previous_id
    return nil if index_in_parent == nil
    return nil if index_in_parent-1 < 0
    return parent.subdoc_refs[index_in_parent-1]
  end

  # Assume that receiver is subdocument k of parent.
  # Return the id of subdocuemnt k + 1 or nil
  def next_id
    p = parent
    return nil if parent == nil
    return nil if index_in_parent+1 > p.subdoc_refs.length
    p.subdoc_refs[index_in_parent+1]
  end

  # Return title and id of NSDocument
  def info
    "#{self.title}:: id: #{self.id}"
  end

  # Return title, id, an ids of previous and next documents
  def status
    "#{self.title}:: id: #{self.id}, parent: #{self.parent.id }, back: #{self.doc_refs['previous']}, next: #{@self.doc_refs['next']}"
  end

  # Return next NSDocument.  That is, if @foo, @bar, and @baz
  # are subcocuments in order of @article, then @bar.next_document = @baz
  def next_document
    DocumentRepository.find next_id
  end


  # Return previous NSDocument.  That is, if @foo, @bar, and @baz
  # are subcocuments in order of @article, then @bar.previous_document = @foo
  def previous_document
    DocumentRepository.find previous_id
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

  # *doc.parent* returns nil or the parent object
  def parent
    DocumentRepository.find(parent_id)
  end


  # *doc.subdocment(k)* returns the k-th
  # subdocument of *doc*
  def subdocument(k)
    DocumentRepository.find(subdoc_refs[k])
  end

  # The root_document is what you get by
  # following parent_document links to their
  # source. If the root_document_id is zero,
  # then the document is a root document.
  # Otherwise, the root_document_id is the
  # id of the root_documment.
  def root_document
    if root_document_id == 0
      return self
    else
      DocumentRepository.find(root_document_id)
    end
  end

  # If input is nil, render the content
  # and save it in rendered_content.  Otherwise,
  # Replace #content by str, render it
  # and save itl. .
  def update_content(input=nil)
    if input == nil
      str = self.content || ''
    else
      str = input
      self.content = str
    end
    renderer = Render.new(str)
    self.rendered_content = renderer.convert
    DocumentRepository.update self
  end

  # *doc.compile* concatenates the contents
  # of *doc* with the compiled text of
  # each section of *doc*.  The sections
  # array is determined by #part, which is
  # a persistent array of integers which
  # represent the id's of the sections of
  # *doc*.
  def compile
    if subdoc_refs == []
      return content
    else
      text = content + "\n\n" || ''
      subdoc_refs.each do |id|
        section = DocumentRepository.find(id)
        text  << section.compile << "\n\n"
        # section.xcompile
      end
      return text
    end
  end

  # A table of contents is a list of lists,
  # where the sublists are oof the form
  # [id, title].  #update_table_of_contents
  # creates this list from scratch, then stores
  # it as jsonb in the toc field of the database
  def update_table_of_contents
    value = []
    subdoc_refs.each do |id|
      value << [id, DocumentRepository.find(id).title]
    end
    self.toc = value
    DocumentRepository.update(self)
    value
  end


  # NSDocument#render is the sole connection between class NSDocument and
  # module Render.  It updates self.rendered_content by applying
  # Asciidoctor.convert to self.content with the provided options.
  def render
    puts "@render_options['format'] = #{@render_options['format']}"
    if @render_options['format'] == 'adoc'
      renderer = Render.new(self.content)
      self.rendered_content = renderer.convert
    elsif @render_options['format'] == 'adoc-latex'
      renderer = Render.new(self.content, {backend: 'html5'} )
      self.rendered_content = renderer.convert
    else
      self.content
    end
    DocumentRepository.update(self)
  end

  # Compile the receiver, render it, and store the
  # rendered text in self.compiled_and_rendered_content
  def compile_with_render
    puts "@render_options['format'] = #{@render_options['format']}"
    if @render_options['format'] = 'adoc'
      renderer = Render.new(self.compile)
      self.compiled_and_rendered_content = renderer.convert
    elsif @render_options['format'] = 'adoc-latex'
      renderer = Render.new(self.compile, {backend: 'html5'} )
      self.compiled_and_rendered_content = renderer.convert
    else
      self.compiled_and_rendered_content = self.content
    end
    DocumentRepository.update(self)
  end



end
