require 'asciidoctor'
str = IO.read(ARGV[0])
a = Asciidoctor.load str, {sourcemap: true}
b = a.blocks

def spacing(block)
  "  "*block.level
end

def list(block_array)
  block_array.each do |block|
    puts "#{spacing(block)}#{block.title}" if block.title
    if block.blocks
      list(block.blocks)
    end
  end
end
=begin
b.each do |block|
  puts block.title
end
=end


list(b)
