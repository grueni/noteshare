require 'pry'
require 'open-uri'

module Noteshare
  module Core
    module Text
      # class Render provides text-rendering
      # service via Render.convert.  It takes
      # Asciidoc or Asciidoc-LaTeX as input ahd
      # produces HTML as output
      class Render

        require 'asciidoctor'
        require 'asciidoctor-latex'

        attr_reader :index

        include Asciidoctor

        def initialize(source, options = {})
          @source = source
          @options = options
          @root_doc_id = @options['root_doc_id']
        end




        def make_index
          @indexer = DocumentIndex.new(string: @source)
          @indexer.preprocess_to_string
          @source = @indexer.output
          @index = @indexer.document_index
          @source << "\n:!sectnums:\n\n== Index\n\n" << @index
        end

        ####

        def append_glossary
          glossary = Glossary.new(@source)
          glossary_text = glossary.table
          @source << "\n\n" << glossary_text << "\n\n"
        end

        ####

        def handle_xlinks
          if @options[:xlinks] == 'internalize'
            internalize_xlinks
          else
            rewrite_xlinks
          end
        end

        def write_header
          @source = ":source-highlighter: coderay\n\n#{@source}"
        end

        def prepare_adoc
          @options = @options.merge({:verbose => 0, :safe => :safe})
          write_header
          rewrite_media_urls
          handle_xlinks
          make_index if @options[:make_index]
          append_glossary if @source.include?  ':glossary:'
        end

        def convert
          prepare_adoc
          Asciidoctor.convert(@source, @options)
        end

        def export_asciidoc
          @options = @options.merge({verbose:0})
          rewrite_urls
        end


        def rewrite_media_urls

          rxTag = /(image|video|audio)(:+)(.*?)\[(.*)\]/
          scanner = @source.scan(rxTag)
          count = 0

          scanner.each do |scan_item|
            count += 1

            media_type = scan_item[0]
            infix = scan_item[1]
            id = scan_item[2]
            attributes = scan_item[3]

            old_tag = "#{media_type}#{infix}#{id}[#{attributes}]"

            if id =~ /^\d+\d$/
              iii = Noteshare::Core::Image::ImageRepository.find id
              if iii
                new_tag = "#{media_type}#{infix}#{iii.url2}[#{attributes}]"
                @source = @source.sub(old_tag, new_tag)
              end
            end

          end

        end

        def download_file(url, filepath)
          # return unless File.file?(filepath)
          File.open(filepath, "wb") do |saved_file|
            # the following "open" is provided by open-uri
            open(url, "rb") do |read_file|
              saved_file.write(read_file.read) if read_file
            end
          end
        end

        def rewrite_media_urls_for_export
          doc_folder = @options[:doc_folder] || 'a2a2a2'

          rxTag = /(image|video|audio)(:+)(.*?)\[(.*)\]/
          scanner = @source.scan(rxTag)
          count = 0

          scanner.each do |scan_item|
            count += 1

            media_type = scan_item[0]
            infix = scan_item[1]
            id = scan_item[2]
            attributes = scan_item[3]

            old_tag = "#{media_type}#{infix}#{id}[#{attributes}]"

            if id =~ /^\d+\d$/
              iii = Noteshare::Core::Image::ImageRepository.find id
              if iii
                download_file_name = iii.file_name.sub('image::', 'image_')
                download_path = "outgoing/#{doc_folder}/images/#{download_file_name}"
                new_tag = "image::images/#{download_file_name}[#{attributes}]"
                download_file(iii.url2, download_path)
                @source = @source.sub(old_tag, new_tag)
              end
            end

          end

        end

        def old_xlink_string(scan_item)
          selector = scan_item[0]
          link_text = scan_item[1]
          "xlink::#{selector}[#{link_text}]"
        end

        def new_xlink_string(scan_item)
          selector = scan_item[0]
          link_text = scan_item[1]

          score = 0
          score = score + 1 if selector =~ /\#/
          score = score + 2 if selector =~ /\?/

          if score > 0
            m = selector.match /(.*?)[\#|\?](.*)/
            numerical_id = m[1]
            argument = m[2]
          else
            numerical_id = selector
          end

          case score
            when 0
              str = "#{selector}"
            when 1
              str = "#{selector}" # it is a reference
            when 2
              str = "#{numerical_id}?#{argument}"  # it is an option
            when 3
              args = argument.split('?')
              str = "#{numerical_id}?ref:#{args[0]},opt:#{args[1]}"
            else
          end

          if ENV['MODE'] == 'LVH'
            prefix = "http://www#{ENV['DOMAIN']}:#{ENV['PORT']}"
          else
            prefix = "http://www#{ENV['DOMAIN']}"
          end

          "#{prefix}/link/#{str}[#{link_text}]"
        end

        def rewrite_xlink(scan_item)
          @source = @source.gsub(old_xlink_string(scan_item), new_xlink_string(scan_item))
        end

        def rewrite_xlinks
          scanner = @source.scan(/xlink::(.*?)\[(.*?)\]/m)
          scanner.each do |scan_item|
            rewrite_xlink(scan_item)
          end
        end

        def old_reference(id, label)
          "xlink::#{id}[#{label}]"
        end

        def numerical_id(id)
          id = id.to_s
          if (id =~ /\A\d*/) == 0    # begins with numerical id, that is, a file ID

            if id =~ /[\#|\?]/
              m = id.match /(\A\d*?)[\?|\#](.*)/
              numerical_id = m[1]
            else
              numerical_id = id
            end
            numerical_id
          end

        end

        def new_reference(id, label)
          id = id.to_s
          if (id =~ /\A\d*/) == 0    # begins with numerical id, that is, a file ID

            if id =~ /[\#|\?]/
              m = id.match /(\A\d*?)[\?|\#](.*)/
              numerical_id = m[1]
            else
              numerical_id = id
            end

            doc = Noteshare::Core::Document::DocumentRepository.find numerical_id

            if doc
              new_id = "_#{doc.title.normalize('alphanum')}"
              return "<<#{new_id}, #{label}>>"
            else
              return nil
            end

          else
            new_id = id.split('#')[1]
            new_id = new_id.normalize('alphanum')
            new_id = new_id.gsub(" ", '_')
            return "<<#{new_id}, #{label}>>"
          end

        end

        def internalize_xlink(match)
          id = match[0]
          label = match[1]
          new_ref = new_reference(id, label)
          if numerical_id(id) == @root_doc_id
            @source = @source.gsub(old_reference(id, label), new_ref) if new_ref
          else
            rewrite_xlink(match)
          end
        end


        # Example:
        # "xlink::540[Further reading]" =>  "<<_atomic_theory, Further reading>>"
        def internalize_xlinks
          xlink_rx = /xlink::(.*?)\[(.*?)\]/
          scan = @source.scan xlink_rx
          scan.each do |match|
            internalize_xlink(match)
          end
        end


        def source
          @source
        end

      end

    end
  end
end

