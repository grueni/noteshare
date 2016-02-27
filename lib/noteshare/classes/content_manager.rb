

# Public interface:
#
#   - update_content
#   - update_content_lazily
#   - compile_with_render_lazily
#   - export
#
####################
class ContentManager


  def initialize(document, options = {})
    @document = document
    @options = options
    @root_document = @document.root_document
    configure_format
    configure_index
  end

  def configure_format
    if @root_document
      @format = @root_document.render_options['format']
    else
      @format = 'adoc'
    end
  end

  def configure_index
    if @document.dict['make_index']
      @options[:make_index] = true
    end
  end

  # Return the compiled source text of @document
  # Uses NSDocument#compile to recurse over subdocuments
  def compile
    asciidoctor_attributes + substitutions + texmacros + @document.compile
  end

  # Compile, render, and update @document
  # Set #content_dirty to false
  def render
    renderer = Render.new(compile, @options )
    @document.rendered_content = renderer.convert
    @document.content_dirty = false
    DocumentRepository.update(@document)
  end

  # OK?
  # Two external uses
  # Compile the receiver, render it, and store the
  # rendered text in @document.compiled_and_rendered_content
  def compile_with_render
    start = Time.now

    # Compile the document and save the compilation if the document
    # is a root document: the compilation is used to build the internal
    # table of contents
    _compiled_content = compile
    @document.compiled_content = _compiled_content if @document.is_root_document?

    # Render the content
    renderer = Render.new(_compiled_content, @options )
    @document.compiled_and_rendered_content = renderer.convert


    # Set flags, update, and report timings
    @document.compiled_dirty = false
    value = DocumentRepository.update(@document)
    finish = Time.now
    elapsed = finish - start
    puts "Compile with render in #{elapsed} seconds".red
    return value
  end


  # OK
  # Extensive external use
  def compile_with_render_lazily
    if @document.compiled_dirty
      puts "document #{@document.title} is DIRTY -- compiling and rendering".red
      t = Time.now
      compile_with_render
      t2 = Time.now
      puts "Time for compile and render = #{t2 - t} seconds".red
    else
      puts "document #{@document.title} is CLEAN".red
    end
  end


  # OK
  # One external use


  def set_content_dirty
    @document.content_dirty = true
  end

  def set_content_clean
    @document.content_dirty = false
  end

  # OK
  # used internally by process_document
  # and externally by controller Edit
  def update_content_lazily(input=nil)
    if @document.rendered_content == nil or @document.content_dirty or @document.rendered_content.length < 3
      puts "Document #{@document.title} is DIRTY".red
      t = Time.now
      update_content(input)
      t2 = Time.now
      puts "updated in #{t2-t} seconds".red
    else
      puts "Document #{@document.title} is CLEAN".red
    end
  end


  ### FIRST CHECK OF INTERFACE TO THIS POINT ###

  # OK?
  # One external use
  def export
    header = '= ' << @document.title << "\n"
    header << @document.author << "\n"
    header << ":numbered:" << "\n"
    header << ":toc2:" << "\n\n\n"

    renderer = Render.new(header + texmacros + @document.compile, @options )
    renderer.rewrite_urls
    file_name = @document.title.normalize
    path = "outgoing/#{file_name}.adoc"
    IO.write(path, renderer.source)
    export_html

  end

  def prepare_content(new_content)

    if @document
      prefix = "="*(@document.level + 2)
    else
      prefix = "== "
    end

    if @document
      new_title = @document.title
    else
      new_title = 'TITLE'
    end

    header = "#{prefix} #{new_title}"

    if new_content
      prepared_content = "#{header}\n\n#{new_content}"
    else
      prepared_content = header
    end

    @document.content = prepared_content
  end


  ############# INTERNAL ############

  # used only by update_content
  def set_compile_dirty
    head = @document.root_document
    if head.compiled_dirty == false
      head.compiled_dirty = true
      DocumentRepository.update head
    end
  end

  # used only by update_content
  def update_content_from(str)
    renderer = Render.new(asciidoctor_attributes + substitutions + texmacros + str, @options)
    @document.rendered_content = renderer.convert
  end

  # Used internally by update_content_lazily
  # If input is nil, render the content
  # and save it in rendered_content.  Otherwise,
  # Replace #content by str, render it
  # and save it ...
  def update_content(input=nil)

    set_compile_dirty

    # dirty = @document.content_dirty
    # dirty = true if dirty.nil?
    # return if dirty == false

    if input == nil
      str = @document.content || ''
    else
      str = input
      @document.content = str
    end

    render_by_identity = @document.dict['render'] == 'identity'
    if render_by_identity
      @document.rendered_content =  content
    else
      update_content_from(str)
    end

    @document.synchronize_title

    @document.content_dirty = false
    DocumentRepository.update @document

  end

  # OK
  # All uses are internal:
  # compie, export, an update_content_from
  def texmacros
    rd = @document.root_document || @document
    macro_text = ''
    if rd and rd.doc_refs['texmacros']
      macro_text << rd.associated_document('texmacros').content
      macro_text = macro_text.gsub(/^=*= .*$/,'')
      macro_text = "\n\n[env.texmacro]\n--\n#{macro_text}\n--\n\n"
    end
    macro_text << "\n"
  end



  # OK?
  # Used internally by compile and update_content_from
  #
  # Get dict['substitutions'], e.g., app, Scripta; foo, bar;
  # then turn it into a hash, e.g., {'app' => 'Scripta', 'foo' => 'bar'}
  # and finally turn it into a string representing text substitutions
  # for Asciidoctor, e.g.
  # :app: Scritpa
  # :foo: bar
  def substitutions
    root_doc = @document.root_document
    substitution_string = root_doc.dict['substitutions'] || ''
    substitution_hash = substitution_string.hash_value(',;')
    str = ''
    substitution_hash.each do |key, value|
      str << ":#{key}: #{value}\n"
    end
    str << "\n"
  end

  # OK?
  # Used internally by compile and update_content_from
  #
  def asciidoctor_attributes
    root_doc = @document.root_document
    attr_string = root_doc.dict['substitutions'] || ''
    attr_list = attr_string.split(',').map{ |x| x.strip }
    str = ''
    attr_list.each do |attr|
      str << ":#{attr}:\n"
    end
    str << "\n"
  end


  # One internal use
  def export_html

    file_name = @document.title.normalize
    path = "outgoing/#{file_name}.adoc"

    case @format
      when 'adoc'
        cmd = "asciidoctor #{path}"
      when 'adoc-latex'
        cmd = "asciidoctor-latex -b html #{path}"
      else
        cmd = "asciidoctor #{path}"
    end

    system cmd

  end

end