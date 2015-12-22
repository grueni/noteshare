

module Editor::Controllers::Document
  class UpdateOptions
    include Editor::Action

    expose :document, :active_item

    def process_options(document, option)
      dirty = false
      hash = option.hash_value(key_value_separator: ':', item_separator: "\n")
      puts "IN PROCESS_OPTIONS, OPTION HASH = #{hash}".red
      if hash
        document.render_options['format'] = hash['format']
        puts "Set document render_options to #{hash['format']}".red
        dirty = true
      end
      hash.each do |key, value|
        document.dict[key] = value
      end
      return dirty
    end


    def update_meta(document, document_packet)

      puts" document_packet: #{document_packet}\n"

      dirty = false

      if document_packet['tags'] != ''
        document.tags = document_packet['tags']
        puts "tags = #{document_packet['tags']}"
        dirty = true
      end

      if document_packet['options'] != ''
        options = document_packet['options']
        puts "options = #{document_packet['options']}"
        dirty_options = process_options(document, options)
        dirty = dirty || dirty_options
      end

      if dirty
        DocumentRepository.update(document)
      end

    end

    def call(params)
      @active_item = 'editor'
      puts ">> Editor update options (CONTROLLER)".yellow

      document_packet = params.env['rack.request.form_hash']['document']

      id =  document_packet['document_id']
      if id
        document = DocumentRepository.find id
        update_meta(document, document_packet)
      end

      redirect_to "/editor/document/#{id}"
    end

  end
end
