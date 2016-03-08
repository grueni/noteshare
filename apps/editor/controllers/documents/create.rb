# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include editor::action
    include nsdocument::asciidoc

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
      redirect_if_not_signed_in('editor, documents, create')

      puts "controller create!!!".red
      @author = current_user(session)

      doc_params = params[:document]
      title = doc_params['title']
      if title == nil or title == ''
        redirect_to '/error/:0?please enter a title for the document'
      end

      # set up author
      @author_credentials = @author.credentials

      # set up document
      @document = nsdocument.create(title: title, author_credentials: @author_credentials)
      @document.content = "= #{title}\n// document header\n// material before first section"
      @document.author = @author.full_name

      #fixme: the following is to be deleted when author_id is retired
      @document.author_id = @author.credentials[:id].to_i

      @document.render_options = get_format(@author)
      make_first_section
      update_user_dict
      @document.compiled_dirty = false
      documentrepository.update @document
      @document.acl_set_permissions!('rw', 'r', '-')
      update_user_node
      redirect_to "document/#{@first_section.id}"
    end

    def update_user_node
      user_node = @author.node
      if user_node
        user_node.publish_document(id: @document.id, type: 'author')
        nsnoderepository.update user_node
      end
    end

    def update_user_dict
      @author.dict2['root_documents_created'] = @author.dict2['root_documents_created'].to_i + 1
      userrepository.update @author
    end

    def make_first_section
      flag = @author.dict2['root_documents_created']
      if flag == nil or flag == '' or flag.to_i == 0
        @author.dict2['root_documents_created'] = 1
      end

      if @author.dict2['root_documents_created'].to_i < 2
        @first_section = nsdocument.create(title: 'first section', content: sample_content, author_credentials: @author_credentials)
      else
        @first_section = nsdocument.create(title: 'first section', content: "== first section\n\n", author_credentials: @author_credentials)
      end

      cm = contentmanager.new(@first_section)
      cm.update_content
      @first_section.add_to(@document)
    end

    def sample_content

      _content = <<eof
#the sample content below is just to help you get started.
modify it or delete it as you wish.  to create a new section,
click on the "+" button, above left in the toolbar.#

// how to make a section title:
== example text
// always start with "==" followed by a space.

// this is how you insert an image:
image::460[width=200, float=right]

//simple asciidoc formatting:
*note:* this is _only a test!_

// use latex if you need it for formulas
$a^2 + b^2 = c^2$

// make a numbered list:
. orange juice
. milk
. cereal
// use * instead of . for itemized lists.

// refer to a web page:
_i read the http://nytimes.com[new york times] every day._


#for more info, see the xlink::530[user guide]#

note: this sample content appears only the first time
you create a document.

eof
      _content
    end

  end
end