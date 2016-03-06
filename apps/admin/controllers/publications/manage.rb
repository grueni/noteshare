module Admin::Controllers::Publications
  class Manage
    include Admin::Action

    expose :publications, :active_item,  :screen_name

    def call(params)

      @screen_name = current_user(session).screen_name

      @active_item = 'admin'
      _publications = PublicationsRepository.all.sort_by{ |record| record.document_title }
      @publications = []
      _publications.each do |publication|

        hash = {}

        hash[:record] = publication

        hash[:node_id] =  publication.node_id
        node = NSNodeRepository.find publication.node_id
        node ? hash[:node_name] = node.name : hash[:node_name] ='NIL'

        hash[:document_id]  =  publication.document_id
        doc = DocumentRepository.find publication.document_id
        doc ? hash[:document_title] = doc.title : hash[:document_title] = 'NIL'

        hash[:type] = publication.type

        @publications << hash
      end
    end
  end
end
