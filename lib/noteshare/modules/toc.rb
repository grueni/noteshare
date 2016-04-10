require_relative 'toc_item'
require_relative '../classes/document/toc_presenter'

module Noteshare::Core

  class TOC

    attr_reader :toc_array

    # A TOC object is initialized
    # from a document and represents
    # the document.toc array of hashes
    # in @table as an array of TOCItems.
    #
    # A TOCItem is a struct with fields
    # id, :title, :identifier, :has_subdocs

    # A toc_array is an array of hashes
    # where each hash has keys
    # :id, :title, and :identifier
    #
    # The toc_array of a document
    # determines its structure,
    # essentially the ordered list
    # of its subdocuments ("sections")


    def initialize(document)
      @document = document
      @toc_array = @document.toc

      @table = []

      @toc_array.each do |item|
        toc_item =  TOCItem.from_hash(item)
        @table << toc_item
      end
    end

    def title
      @document.title
    end

    def display
      str = "\n-------\nTABLE:\n"
      @table.each do |item|
        str << item.display
      end
      str << "-------\n#{@table.count}\n"
    end

    def table
      @table
    end

    def count
      return table.count
    end

    def save
      new_table = table.map{ |item| item.to_h}
      @document.toc = new_table
    end

    def save!
      save
      DocumentRepository.update @document
    end

    def insert(k, toc_item)
      @table.insert(k, toc_item)
    end

    def append(toc_item)
      @table << toc_item
    end

    def delete(k)
      @table.delete_at(k)
    end

    def delete_by_id(id)
         k = index_by_id(id)
         delete(k)
    end

    def delete_by_identifier(identifier)
      k = index_by_identifier(identifier)
      delete(k)
    end

    def index_by_id(id)
      index_of_id = -1
      table.each_with_index do |item, index|
        if item.id == id
          index_of_id = index
          break
        end
      end
      index_of_id
    end

    def index_by_identifier(identifier)
      index_of_identifier = -1
      table.each_with_index do |item, index|
        if item.identifier == identifier
          index_of_identifier = index
          break
        end
      end
      index_of_identifier
    end

    # Return the toc item with given id
    def get_by_id(id)
      target = nil
      table.each do |item|
        if item.id == id
          target = item
          break
        end
      end
      target
    end


    # Return the toc item with given id
    def get_by_doc_title(title)
      target = nil
      table.each do |item|
        if item.title == title
          target = item
          break
        end
      end
      target
    end


    def title_by_id(id)
      get_by_id(id).title
    end

    def change_title(id, new_title)
      target = nil
      table.each do |item|
        if item.id == id
          target = item
          target.title = new_title
          break
        end
      end
      target
    end


    # Swap TOC entries for the given identifiers
    def swap(subdocument1, subdocument2)
      index1 = index_by_identifier(subdocument1.identifier)
      index2 = index_by_identifier(subdocument2.identifier)
      item1 = @table[index1]
      item2 = @table[index2]
      @table[index1] = item2
      @table[index2] = item1
      self.save!
    end

  end # of class TOC

  class OuterTableOfContents

    # exmaples:
    # options = {active_id: 44}
    def initialize(document, attributes, options)

      @document = document
      @attributes = attributes
      @options = options

      @active_id = @options[:active_id]
      @active_document = DocumentRepository.find(@active_id)
      @target = @options[:target] || 'reader'

      @toc = @document.toc
      @table = TOC.new(document).table

    end

    def dragula_table

      # http://codepen.io/rachelslurs/pen/EjKmLG
      # http://js-tutorial.com/dragula-drag-and-drop-so-simple-it-hurts-1483
      # https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model/Introduction

      return '' if @toc.length == 0

      output = "<div id = 'toc_editor-defaults' class = 'container'>\n"
      output << '  <div id="drag-elements">' << "\n"

      @table.each_with_index do |item, index|

        output << "    <div id=#{index} class='dragula_toc'>#{item.title}</div>\n"

      end

      output << '  </div>' << "\n"
      output << "</div>\n\n"

    end


    # If active_id matches the id of an item
    # in the table of contents, that item is
    # marked with the css 'active'.  Otherwise
    # it is marked 'inactive'.  This way the
    # TOC entry for the document being currently
    # viewed can be highlighted.``
    #
    def master_table_of_contents(target='reader')
      start = Time.now
      return '' if @toc.length == 0

      @ancestral_ids = []
      (@ancestral_ids << @active_document.ancestor_ids << @active_document.id) if @active_document
      @target == 'editor'? output = "<ul class='toc2'>\n" : output = "<ul class='toc2'>\n"

      @table.each do |item|
        output << toc_item(item)
        dive(item, output)
      end

      finish = Time.now
      elapsed = finish - start
      puts "\nTable Of_Contents: elapsed time = #{elapsed}\n".magenta

      output << "</ul>\n\n"
    end

    def toc_item(item)

      "<li>#{item.title}</li>\n"  if @attributes.include? 'dumb'

    end

    def dive(item, output)

      attributes = @attributes.dup << 'skip_first_item'

      item.id == @active_id ?   attributes << 'internal' : attributes << 'external'
      attributes << 'inactive' if @target == 'editor'

      doc = DocumentRepository.find item.id
      return '' if doc == nil

      itoc = TOCPresenter.new(doc).internal_table_of_contents(attributes, {doc_id: doc.id} )
      output << itoc
      # Fixme: memoize, make lazy what we can.

      if doc.toc.count > 0
        otc = OuterTableOfContents.new(doc, @attributes, active_id: @active_id)
        output << "\n" << otc.master_table_of_contents << "\n"
      end


    end

  end


end