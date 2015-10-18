


module Render

  require 'asciidoctor'
  require 'asciidoctor-latex'

  include Asciidoctor


  def self.convert(source, options)
    Asciidoctor.convert(source, options)
  end


end

