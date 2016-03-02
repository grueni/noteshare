# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include Editor::Action
    include NSDocument::Asciidoc

    def get_format(author)
      author_format = author.dict2['format']
      if author_format
        format_hash = {format: author_format}
      else
        format_hash = {format: 'adoc-latex'}
      end
      format_hash
    end

    expose :document

    def call(params)
      redirect_if_not_signed_in('editor, documents, Create')
      puts "controller create!!!".red
      doc_params = params[:document]
      title = doc_params['title']
      _author = current_user(session)
      _author_credentials = _author.credentials

      @document = NSDocument.create(title: title, author_credentials: _author_credentials)
      @document.content = "= #{title}\n// Document header\n// Material before first section"
      @document.author = _author.full_name

      #Fixme: the following is to be deleted when author_id is retired
      @document.author_id = _author.credentials[:id].to_i
      @document.render_options = get_format(_author)

      _content = <<EOF
#The sample content below is just to help you get started.
Modify it or delete it as you wish.  To create a new section,
click on the "+" button, above left in the toolbar.#

// How to make a section title:
== Example text
// Always start with "==" followed by a space.

// This is how you insert an image:
image::460[width=200, float=right]

//Simple Asciidoc formatting:
*Note:* This is _only a test!_

// Use LaTeX if you need it for formulas
$a^2 + b^2 = c^2$

// Make a numbered list:
. Orange Juice
. Milk
. Cereal
// Use * instead of . for itemized lists.

// Refer to a web page:
_I read the http://nytimes.com[New York Times] every day._


#For more info, see the xlink::530[User Guide]#

EOF



      @first_section = NSDocument.create(title: 'Example text',
                                         content: _content, author_credentials: _author_credentials)

      cm = ContentManager.new(@first_section)
      cm.update_content

      # cm = ContentManager.new(@first_section)
      # cm.update_content
      @first_section.add_to(@document)

      @document.compiled_dirty = false
      DocumentRepository.update @document

      @document.acl_set_permissions!('rw', 'r', '-')

      user = current_user(session)
      user_node = user.node
      if user_node
        user_node.publish_document(id: @document.id, type: 'author')
        NSNodeRepository.update user_node
      end

      redirect_to "document/#{@first_section.id}"
    end

  end
end