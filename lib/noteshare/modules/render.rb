

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
    puts "Asciidoctor will convert with option = #{@options}"
    Asciidoctor.convert(@source, @options)
  end


end

