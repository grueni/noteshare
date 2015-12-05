require 'asciidoctor'
str = IO.read(ARGV[0])
doc = Asciidoctor.load str, {sourcemap: true}

def spacing(section)
  "  "*section.level
end

sections = doc.find_by context: :section
sections.each do |section|
  puts "#{spacing(section)}#{section.title}"
end
