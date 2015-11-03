

# Provide presentation methods to NSDocument
module NSDocument::Presentation

  #Fixme: these parameters should be extracted from 'request.env'
  SERVER_NAME = 'localhost'
  SERVER_PORT = 2300

  ############################################################
  #
  #   TITLES
  #
  ############################################################

  def parent_document_title
    p = parent
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
    list = []
    if [:header].include? option
      list << self.title.upcase
    end
    subdoc_refs.each do |id|
      section = DocumentRepository.find(id)
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
  #   TABLE OF CONTENTS & MAP
  #
  ############################################################

  # Return a string representing the table of
  # contents.  The format of the string can
  # be modified by the choice of the option
  # passed to the method.  The default 'simple_string'
  # option gives a numbered list of titles.
  def table_of_contents(hash)
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
            output << "<li><a href='http://#{SERVER_NAME}:#{SERVER_PORT}/document/#{item['id']}'>#{item['title']}</a>\n"
            if noa_id and item['id'] == noa_id
              output << "<ul>\n" << noa.table_of_contents(format: 'html', current_document: nil) << "</ul>"
            end
          end
          output << "</ul>\n\n"
        end
      else
        output = toc.to_s
    end
    output
end


  # If active_id matches the id of an item
  # in the table of contents, that item is
  # marked with the css 'active'.  Otherwise
  # it is marked 'inactive'.  This way the
  # TOC entry for the document being currently
  # viewed can be highlighted.
  #
  def master_table_of_contents(active_id)
    self.update_table_of_contents(force: true) if toc_is_dirty
    
    if toc.length == 0
      output = ''
    else
      output = "<ul class='toc'>\n"
      toc.each do |item|

        # Compute list item:
        doc_id = item['id']
        doc_title = item['title']
        doc_link = "href='http://#{SERVER_NAME}:#{SERVER_PORT}/document/#{doc_id}'>#{doc_title}</a>"
        if doc_id == active_id
          output << "<li class='toc active'><a #{doc_link}</a>\n"
        else
          output << "<li class='toc inactive'><a #{doc_link}</a>\n"
        end

        # Fixme: need to make udpate_table_of_contents lazy
        # Fixme: Updating the toc will need to be done elswhere - or big performance hit
        # Fixme: pehaps call 'update_table_of_contents' in the update controller
        doc = DocumentRepository.find item['id']
        # doc.update_table_of_contents

        # Recursion:
        if doc.toc.length > 0
          output << "<ul>\n" << doc.master_table_of_contents(active_id) << "</ul>"
        end

      end
      output << "</ul>\n\n"
    end
    output
  end


  ############################################################
  #
  #   ASSOCIATED DOCUMENTS
  #
  ############################################################



  def associated_document_map
    hash = self.doc_refs
    keys = hash.keys
    if keys
      keys.delete "previous"
      keys.delete "next"
      map = "<ul>\n"
      keys.each do |key|
        map << "<li>" << "#{self.associate_link(key)}</li>\n"
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
    str << "<li>Up: #{self.parent_link}</li>\n"  if self.parent and self.parent != self.root_document
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
  # Fixme: the server name and port should be extracted
  # from 'request.env'
  def url(prefix='')
    server =  SERVER_NAME # request.env['SERVER_NAME']
    port = SERVER_PORT # request.env['SERVER_PORT']
    if prefix == ''
      "http://#{server}:#{port}/document/#{self.id}"
    else
      "http://#{server}:#{port}/#{prefix}/document/#{self.id}"
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
    root_document.link(hash)
  end

  # HTML link to parent document
  def parent_link(hash = {})
    p = self.parent
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


  def associate_link(type)
    "<a href='/document/#{self.doc_refs[type]}'>#{type.capitalize}</a>"
  end



end