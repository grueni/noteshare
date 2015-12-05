                                                                                                                                                                                                                                                                                  require 'asciidoctor'
str = IO.read(ARGV[0])
doc = Asciidoctor.load str, {sourcemap: true}

@level = 0
@previous_level = 0

def spacing(section, offset=0)
  "  "*(section.level + offset)
end

def toc_entry(section)
  "a[href='\##{section.id}'] #{section.title}"
end


sections = doc.find_by context: :section

sections.each do |section|
  @level = section.level
  if @level > @previous_level
    puts "#{spacing(section,-1)}ul"
    @previous_level = @level
  end
  if @level < @previous_level
    puts
  end
  puts "#{spacing(section)}li #{toc_entry(section)}"
end
