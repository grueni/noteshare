=begin

require 'asciidoctor'
include Asciidoctor



module Render


  def convert(options)
    default_options = { backend: 'html5' }
    options = options.merge default_options
    Asciidoctor.convert("this __is_ a test", options)
  end


end

=end