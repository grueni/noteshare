

module Editor::Controllers::Document
  class UpdateOptions
    include Editor::Action

    expose :document, :active_item


    def propagate(document, hash)
      if hash['format']
        document.apply_to_tree(:set_format_of_render_option, [hash['format']])
      end
    end

    def update_dict(document, hash)
      hash.each do |key, value|
        puts "key = [#{key}], [#{value}]".red
        if value == ''
          puts "delete key #{value}".cyan
          document.dict.delete(key)
        else
          puts "set: #{key} = #{value}".cyan
          document.dict[key] = value
        end
      end
    end

    def process_hash(document, hash)

      update_dict(document, hash)
      propagate(document, hash) if @mode == 'root'
      DocumentRepository.update document

    end


    def update_meta(document, document_packet)

      puts "document_packet: #{document_packet}".red

      if document_packet['tags'] != ''
        document.tags = document_packet['tags']
      end

      if document_packet['options'] != ''
        options = document_packet['options']
        return if options == nil
        hash = options.hash_value(":\n")
        process_hash(document, hash) if hash
      end

      DocumentRepository.update(document)

    end

    def call(params)
      @active_item = 'editor'
      #  @mode = if document_packet['mode'] == 'root'

      document_packet = params.env['rack.request.form_hash']['document']
      @mode = document_packet['mode']

      id =  document_packet['document_id']
      if id
        document = DocumentRepository.find id
        document = document.root_document if @mode == 'root'
        puts "In UpdateOptions, document = #{document.title}".red
        update_meta(document, document_packet)
      end

      redirect_to "/editor/document/#{id}"
    end

  end
end
