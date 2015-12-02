

# module Render provides text-rendering
# service via Render.convert.  It takes
# Asciidoc or Asciidoc-LaTeX as input ahd
# produces HTML as output
class Render

  require 'asciidoctor'
  require 'asciidoctor-latex'

  include Asciidoctor

  def initialize(source, options = {})
    @source = source
    @options = options
  end

  def convert
    @options = @options.merge({verbose:0})
    rewrite_urls
    Asciidoctor.convert(@source, @options)
  end

  def export_asciidoc
    @options = @options.merge({verbose:0})
    rewrite_urls
  end

  def rewrite_urls(option={destination: 'web'})

    rewrite_media_urls('image', option)
    # @source = self.rewrite_media_urls('video', option)
    # @source = self.rewrite_media_urls('audio', option)

  end

  def rewrite_media_urls(tag, option)

    rxTag = /(#{tag}:+.*?\])/
    rxParts = /#{tag}:+(.*?)\[(.*)\]/
    scanner = @source.scan(rxTag)
    count = 0

    scanner.each do |tag_scan|
      count += 1
      old_tag = tag_scan[0]
      part = old_tag.match rxParts
      id = part[1]
      attributes = part[2]
      iii = ImageRepository.find id
      if iii
        new_tag = "#{tag}::#{iii.url2}[#{attributes}]"
        @source = @source.sub(old_tag, new_tag)
      else
        puts "Image #{id} not found".red
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
