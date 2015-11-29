require_relative 'toc_item'

module Noteshare
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
    def get(id)
      target = nil
      table.each do |item|
        if item.id == id
          target = item
          break
        end
      end
      target
    end

    def get_title(id)
      get(id).title
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


  end
end