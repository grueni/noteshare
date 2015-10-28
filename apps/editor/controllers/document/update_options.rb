

module Editor::Controllers::Document
  class UpdateOptions
    include Editor::Action

    expose :document

    def process_options(document, option)
      puts "IN PROCESS_OPTIONS, options = #{option}".red
      dirty = false
      hash = option.hash_value
      puts "IN PROCESS_OPTIONS, OPTION HASH = #{hash}".red
      if hash
        document.render_options = hash['format']
        puts "Set document render_options to #{hash['format']}".red
        dirty = true
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

      if document_packet['area'] != ''
        document.area = document_packet['area']
        puts "area = #{document_packet['area']}"
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
      puts ">> Editor update options (CONTROLLER)".yellow

      document_packet = params.env['rack.request.form_hash']['document']

      id =  document_packet['document_id']
      if id
        document = DocumentRepository.find id
        update_meta(document, document_packet)
      end

      redirect_to "/document/#{id}"
    end

  end
end
