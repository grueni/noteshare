

class TOCPresenter
  
  def initialize(document)
    @document = document
  end

  ####### INTERFACE #######

  # root_table_of_contents
  # internal_table_of_contents


  # Return TOC object corresponding to the toc
  # field in the database
  def table_of_contents
    TOC.new(@document).table
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
        @document.toc.each_with_index do |item, index|
          output << "#{index + 1}. #{item['title']}" << "\n"
        end
      when 'html'
        if toc.length == 0
          output = ''
        else
          output << "<ul>\n"
          @document.toc.each_with_index do |item, index|
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


  # The active_id is the id of the subdocument which
  # the user has selected.
  def root_table_of_contents(active_id, target='reader')
    root = @document.root_document || @document
    if root
      master_table_of_contents(active_id, target)
    else
      ''
    end
  end



  def process_toc_item(item, active_id, ancestral_ids, target)

    # Fixme: TEMPORARY????

    return '' if item == nil
    doc_id = item.id
    doc_title = item.title || 'NO TITLE'


    case target
      when 'editor'
        prefix = '/editor'
        stem = 'document'
      when 'reader'
        prefix = ''
        stem = 'document'
      when 'compiled'
        prefix = ''
        stem = 'compiled'
      when 'aside'
        prefix = ''
        stem = 'aside'
      else
        prefix = ''
        stem = 'document'
    end

    doc_link = "href='#{prefix}/#{stem}/#{doc_id}'>#{doc_title}</a>"

    class_str = "class = '"

    if item.has_subdocs  # has_subdocs is field of the struct item
      (ancestral_ids.include? item.id) ? class_str << 'subdocs-open ' : class_str << 'subdocs-yes '
    else
      class_str << 'subdocs-no '
    end

    doc_id == active_id ? class_str << 'active' : class_str << 'inactive'

    "<li #{class_str} '><a #{doc_link}</a>\n"

  end

  def process_associated_documents(item, target)
    doc = DocumentRepository.find item.id
    output = ''
    if doc.doc_refs
      prefix = '/editor'
      stem = 'document'
      class_str = 'toc_associated_doc'
      output << "<ul class='toc_associated_doc'>\n"
      doc.doc_refs.each do |type, id|
        puts "doc_ref: #{type} => #{id}".red
        type = "sidebar" if type == "aside"
        doc_link = "href='#{prefix}/#{stem}/#{id}'>#{type}</a>"
        output <<  "<li #{class_str} '><a #{doc_link}</a></li>\n"
      end
      output << "</ul>\n"
    end
    return output
  end


  def dive(item, active_id,  ancestral_ids, target, output)

    attributes = ['skip_first_item', 'auto_level']

    return output if item == nil
    item.id == active_id ?   attributes << 'internal' : attributes << 'external'
    attributes << 'inert' if target == 'editor'

    doc = DocumentRepository.find item.id
    return '' if doc == nil

    toc_presenter =  TOCPresenter.new(doc)
    output << toc_presenter.internal_table_of_contents(attributes, {doc_id: doc.id} )
    # Fixme: memoize, make lazy what we can.

    # Here is where the recursion happens:
    if toc_presenter.table_of_contents.length > 0 and ancestral_ids.include? doc.id
      output << "<ul>\n" << toc_presenter.master_table_of_contents(active_id, target) << "</ul>"
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

    if @document.toc.length == 0
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

    table_of_contents.each do |item|

      output << process_toc_item(item, active_id, ancestral_ids, target)
      output << process_associated_documents(item, target) if target == 'editor'
      dive(item, active_id,  ancestral_ids, target, output)

    end

    finish = Time.now
    elapsed = finish - start

    puts "master_table_of_contents (#{@document.title}), #{elapsed} seconds"

    output << "</ul>\n\n"

  end


  def toc_internal(attributes, options)

    (attributes.include? 'root') ? source = @document.compiled_content : source = @document.content

    Noteshare::AsciidoctorHelper::NSTableOfContents.new(source, attributes, options)

  end


  def internal_table_of_contents(attributes, options)

    (attributes.include? 'root') ? source = @document.compiled_content : source = @document.content

    toc =  Noteshare::AsciidoctorHelper::NSTableOfContents.new(source, attributes, options)

    toc.table || ''


  end



end