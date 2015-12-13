                                                                                                                                                                                                                                                                                  require 'asciidoctor'
str = IO.read(ARGV[0])
a = Asciidoctor.load str, {sourcemap: true}
b = a.blocks

@level = 0
@previous_level = 0

def spacing(block, offset=0)
  "  "*(block.level + offset)
end

def toc_entry(block)
  @level = block.level
  if @level - @previous_level > 0
    prefix = "#{spacing(block,-1)}ul\n"
  else
    prefix = ''
  end
  @previous_level = @level
  "#{prefix}#{spacing(block)}li: a[href='\##{block.id}'] #{block.title}"
end

def list(block_array)
  block_array.each do |block|
    puts toc_entry(block) if block.title
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
