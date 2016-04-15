require_relative '../hash_stack'

module Noteshare
  module Helper
    module Document
      # ActivityManager records
      # the documents a user
      # views and can present
      # a list of this activity
      class DocumentActivityManager

        def initialize(user)
          @user = user
          @array = @user.docs_visited || []
        end

        def record(document)
          dv = DocsVisited.new(@array, ENV['DOCS_VISITED_CAPACITY'])
          dv.push_doc(document)
          @user.docs_visited = dv.stack
          UserRepository.update @user
        end


        def list(view_mode)
          array = @array.reverse
          dv = DocsVisited.new(array, ENV['DOCS_VISITED_CAPACITY'])
          output = "<ul>\n"
          dv.stack.each do |item|
            root_id = item.keys[0]
            data = item[root_id]
            doc_id = data[2]
            doc_title = data[1]
            # root_title = data[0]
            output << "<li class='ns_link'> <a href='/#{view_mode}/#{doc_id}'>#{doc_title}</a></li>\n"
          end
          output << "</ul>\n"
          output
        end

        def last_document_id
          last__item = (@user.docs_visited || []).last
          id = last__item.values[0][2] if  last__item
          if id
            id.to_i
          else
            ENV['DEFAULT_DOCUMENT_ID'].to_i
          end
        end


      end
    end
  end
end

