

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

  def convert
    @options = @options.merge({verbose:0})
    rewrite_media_urls
    make_index if @options[:make_index]
    if @source.include?  ':glossary:'
      append_glossary
    end
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


  def source
    @source
  end

end


=begin
   if option[:xlink] == 'internalize'
      @source = self.internalize_xlinks(source)
    else
      @source = self.rewrite_xlinks(source, option)
    end

=end
