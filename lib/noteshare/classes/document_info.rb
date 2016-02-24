class DocumentInfo
  
  def initialize(document)
    @document = document
  end


  #########################################################################
  #
  #  2. Display info about a document
  #
  #########################################################################

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
        puts "#{field.to_s}: #{@document.send(field)}"
      rescue
        puts "#{field.to_s}: ERROR".red
      end
    end
    puts

  end

  # PUBLIC
  # A convenience method for #display
  def @document.info(id)
    doc = DocumentRepository.find(id)
    doc.display('Document', [:title, :identifier, :author_credentials2, :parent_ref, :root_ref, :render_options, :toc])
  end

  # PUBLIC
  def info
    @document.display('Document', [:title, :identifier, :author, :author_id, :author_credentials2, :parent_id, :parent_ref, :root_document_id, :root_ref, :render_options, :toc, :dict])
  end


  # Return title, id, an ids of previous and next documents
  def status
    "#{@document.title}:: id: #{@document.id}, parent_document: #{@document.parent.id }, back: #{@document.doc_refs['previous']}, next: #{@document.doc_refs['next']}"
  end



  # NOT USED
  # Return html text with links to the root and parent documents
  # as well as previous and next documents if they are present.
  def document_map
    str = "<strong>Map</strong>\n"
    str << "<ul>\n"
    str << "<li>Top: #{@document.root_link}</li>\n"
    str << "<li>Up: #{parent_link}</li>\n"  if @document.parent_document and @document.parent_document != @document.root_document
    str << "<li>Prev: #{previous_link}</li>\n"  if @document.previous_document
    str << "<li>Next: #{next_link}</li>\n"  if @document.next_document
    str << "</ul>\n\n"
  end

  # INTERNAL: Document map only
  # HTML link to parent document
  def parent_link(hash = {})
    p = @document                                                                                                                                                                                                                    .parent_document
    p ? p.link(hash) : ''
  end


  # INTERNAL: Document map only
  # HTML link to next document
  # with arg1 = link text (or image)
  # if the link is valid and arg2
  # = link text (or image)
  # if the link is not valid
  def next_link(hash = {})
    alt_title =  hash[:alt_title] || ''
    n = @document.next_document
    n ? n.link(hash) : alt_title
  end


  def previous_link(hash = {})
    alt_title =  hash[:alt_title] || ''
    n = @document.previous_document
    n ? n.link(hash) : alt_title
  end
end