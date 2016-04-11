
module Noteshare
  module Core
    module Util
      # A HashStack is represented by
      # an array of hashes, e.g.,
      # [{123: 'Poetry Collection'}, {456: 'Electrodynamics'}]
      class HashStack

        def initialize(array, capacity)
          @array = array  || []
          @capacity = capacity.to_i
        end

        def stack
          @array
        end

        def push(item)
          k = find_index(item)
          if k
            stack.delete_at(k)
          end
          @array << item
          @array.shift if count > @capacity
        end

        def pop
          @array.pop
        end

        def keys
          if stack
            stack.map{ |item| item.keys[0] }
          else
            []
          end
        end

        def include?(item)
          keys.include? item.keys[0]
        end

        def find_index(item)
          keys.find_index(item.keys[0])
        end

        def count
          @array.count
        end

      end
    end
  end
end


module Noteshare
  module Helper

    module Document
      include Noteshare::Core::Util

      # Visited Docs manages a stack
      # of entries of the form
      # {doc_id => [title, root_title, root_id]}
      class DocsVisited < HashStack
        def itemize(document)
          rd = document.root_document
          { rd.id.to_s => [ rd.title, document.title, document.id.to_s]}
        end

        def push_doc(document)
          item = itemize(document)
          self.push(item)
        end
      end
    end # module Document

    module Node
      include Noteshare::Core::Util

      # NodesVisited manages a stack
      # of entries of the form
      # {node_id => [name]}
      class NodesVisited < HashStack
        def itemize(node)
          { node.id.to_s => [ node.name ]}
        end

        def push_node(node)
          item = itemize(node)
          self.push(item)
        end
      end
    end # module Node

    module Image
      include Noteshare::Core::Util

     # NodesVisited manages a stack
       # of entries of the form
      # {node_id => [name]}
      class ImagesVisited < HashStack
        def itemize(image)
          { image.id.to_s => [ image.title ]}
        end

        def push_image(image)
          item = itemize(image)
          self.push(item)
        end
      end
    end

  end
end




