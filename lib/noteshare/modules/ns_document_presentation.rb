require_relative '../entities/ns_document'

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

  def root_table_of_contents(active_id, target='reader')
    puts "self.title: #{self.title}".red
    root = root_document || self
    if root
      root.master_table_of_contents(active_id, target)
    else
      ''
    end
  end

  # If active_id matches the id of an item
  # in the table of contents, that item is
  # marked with the css 'active'.  Otherwise
  # it is marked 'inactive'.  This way the
  # TOC entry for the document being currently
  # viewed can be highlighted.``
  #
  def master_table_of_contents(active_id, target='reader')
    puts "ENTER: master_table_of_contents".magenta
   #  self.update_table_of_contents(force: true) if toc_is_dirty
    
    if toc.length == 0
      output = ''
    else

      active_document = DocumentRepository.find(active_id) if active_id > 0
      # Gett "long" ancestor chain: ancestors plust the given active id:
      ancestral_ids = active_document.ancestor_ids << active_document.id
      target == 'editor'? output = "<ul class='toc2'>\n" : output = "<ul class='toc'>\n"

      self.table_of_contents.each do |item|

        # Compute list item:
        doc_id = item.id
        doc_title = item.title
        if target == 'editor'
          doc_link = "href='/editor/document/#{doc_id}'>#{doc_title}</a>"
        else
          doc_link = "href='/document/#{doc_id}'>#{doc_title}</a>"
        end
        class_str = "class = '"

        if item.has_subdocs
          if ancestral_ids.include? item.id
            class_str << 'subdocs-open '
          else
            class_str << 'subdocs-yes '
          end
        else
          class_str << 'subdocs-no '
        end
        doc_id == active_id ? class_str << 'active' : class_str << 'inactive'

        output << "<li #{class_str} '><a #{doc_link}</a>\n"
        # Fixme: need to make udpate_table_of_contents lazy
        # Fixme: Updating the toc will need to be done elswhere - or big performance hit
        # Fixme: pehaps call 'update_table_of_contents' in the update controller
        doc = DocumentRepository.find item.id
        # doc.update_table_of_contents

        if doc.table_of_contents.length > 0 and ancestral_ids.include? doc.id
            #(doc.id == active_document.parent_id) or (doc.id == active_document.id)
          output << "<ul>\n" << doc.master_table_of_contents(active_id, target) << "</ul>"
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



  def associated_document_map(target='reader')
    hash = self.doc_refs
    keys = hash.keys
    if keys
      keys.delete "previous"
      keys.delete "next"
      map = "<ul>\n"
      keys.each do |key|
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
    #Fixme
    if root_document
      root_document.link(hash)
    else
      self.title
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
    puts "PREVIOUS LINK".red
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



end