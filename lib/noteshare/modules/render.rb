


module Render

  require 'asciidoctor'
  require 'asciidoctor-latex'

  include Asciidoctor


  def self.convert(source, options)
    default_options = { backend: 'html5' }
    options = options.merge default_options
    Asciidoctor.convert(source, options)
  end


end

