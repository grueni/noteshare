# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include Editor::Action
    include NSDocument::Asciidoc

    expose :document

    def get_format(author)
      author_format = author.dict2['format']
      if author_format
        format_hash = {format: author_format}
      else
        format_hash = {format: 'adoc-latex'}
      end
      format_hash
    end


    def call(params)

      puts "controller create!!!".red
      @author = current_user2

      doc_params = params[:document]
      title = doc_params['title']
      if title == nil or title == ''
        redirect_to '/error/:0?Please enter a title for the document'
      end

      # set up author
      @author_credentials = @author.credentials

      # set up document
      @document = NSDocument.create(title: title, author_credentials: @author_credentials)
      @document.content = "= #{title}\n// Document header\n// Material before first section"
      @document.author = @author.full_name

      #Fixme: the following is to be deleted when author_id is retired
      @document.author_id = @author.credentials[:id].to_i

      @document.render_options = get_format(@author)
      make_first_section
      update_user_dict
      @document.compiled_dirty = false
      DocumentRepository.update @document
      @document.acl_set_permissions!('rw', 'r', '-')
      DocumentActivityManager.new(@author).record(@first_section)
      update_user_node
      redirect_to "document/#{@first_section.id}"
    end

    def update_user_node
      user_node = @author.node
      if user_node
        user_node.publish_document(id: @document.id, type: 'author')
        NSNodeRepository.update user_node
      end
    end

    def update_user_dict
      @author.dict2['root_documents_created'] = @author.dict2['root_documents_created'].to_i + 1
      UserRepository.update @author
    end

    def make_first_section
      flag = @author.dict2['root_documents_created']
      if flag == nil or flag == '' or flag.to_i == 0
        @author.dict2['root_documents_created'] = 1
      end

      if @author.dict2['root_documents_created'].to_i < 2
        @first_section = NSDocument.create(title: 'First section', content: sample_content, author_credentials: @author_credentials)
      else
        @first_section = NSDocument.create(title: 'First section', content: "== First section\n\n", author_credentials: @author_credentials)
      end

      cm = ContentManager.new(@first_section)
      cm.update_content
      @first_section.add_to(@document)
    end

    def sample_content

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

NOTE: This sample content appears only the first time
you create a document.

EOF
      _content
    end

  end
end