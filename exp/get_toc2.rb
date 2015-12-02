require 'asciidoctor'
str = IO.read(ARGV[0])
a = Asciidoctor.load str, {sourcemap: true}
b = a.blocks

def spacing(block)
  "  "*block.level
end

def toc_entry(block)
  "<li><a href='\##{block.id}'>#{block.title}</a></li>" if block.title
end

def list(block_array)
  puts "<ul>"
  block_array.each do |block|
    puts toc_entry(block)
    if block.blocks
      list(block.blocks)
    end
  end
  puts "</ul>"
end
=begin
b.each do |block|
  puts block.title
end
=end


list(b)
