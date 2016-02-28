

# module Render provides text-rendering
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
    puts "in Render, initialize, @options = #{@options}".magenta
  end




  def make_index
    puts "MAKING INDEX".red
    @indexer = DocumentIndex.new(string: @source)
    @indexer.preprocess_to_string
    @source = @indexer.output
    @index = @indexer.document_index
    puts "In convert, @index = #{@index}".blue
    @source << "\n:!sectnums:\n\n== Index\n\n" << @index
    puts "In convert, @source = #{@source}".cyan
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

  def convert
    @options = @options.merge({verbose:0})
    write_header
    puts "\n-----SOURCE:\n#{@source}\n-----\n".cyan
    rewrite_media_urls
    handle_xlinks
    make_index if @options[:make_index]
    append_glossary if @source.include?  ':glossary:'
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
        iii = ImageRepository.find id
        if iii
          new_tag = "#{media_type}#{infix}#{iii.url2}[#{attributes}]"
          @source = @source.sub(old_tag, new_tag)
        else
          puts "Media #{id} not found".red
        end
        puts "old_tag: #{old_tag}"
        puts "new_tag: #{new_tag}"
      end

    end

  end

  def rewrite_xlinks
      puts "rewrite_xlinks".magenta

      scanner = @source.scan(/xlink::(.*?)\[(.*?)\]/m)
      scanner.each do |scan_item|
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
            str = ''
          when 1
            str = "\##{selector}" # it is a reference
          when 2
            str = "?#{argument}"  # it is an option
          when 3
            reference, option = argument.split('?')
            str = "\#{reference}?#{option}"
          else
        end


        end

        if ENV['MODE'] == 'LVH'
          prefix = "http://www#{ENV['DOMAIN']}:#{ENV['PORT']}"
        else
          prefix = "http://www#{ENV['DOMAIN']}"
        end

        xlink_string = "xlink::#{id}[#{link_text}]"

        puts "xlink_string: #{xlink_string}".cyan

        new_xlink_string = "#{prefix}/link/#{str}[#{link_text}]"

        puts "new_xlink_string: #{new_xlink_string}".cyan

        @source = @source.gsub(xlink_string, new_xlink_string)
    end
  end

  # Example:
  # "xlink::540[Further reading]" =>  "<<_atomic_theory, Further reading>>"
  def internalize_xlinks
    puts "internalize_xlinks".magenta
    xlink_rx = /xlink::(.*?)\[(.*?)\]/
    scan = @source.scan xlink_rx
    scan.each do |match|
      id = match[0]
      label = match[1]
      old_reference = "xlink::#{id}[#{label}]"
      if id =~ /^\d*$/    # numerical id, that is, a file ID
        doc = DocumentRepository.find id
        new_id = "_#{doc.title.normalize('alphanum')}" if doc
      else
        new_id = id.split('#')[1]
        new_id = new_id.normalize('alphanum')
        new_id = new_id.gsub(" ", '_')
      end
      if new_id
        new_reference = "<<#{new_id}, #{label}>>"
        @source = @source.gsub(old_reference, new_reference)
      end
    end
  end


  def source
    @source
  end

end

