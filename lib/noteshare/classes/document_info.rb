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

end