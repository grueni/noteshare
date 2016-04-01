require 'lotus/interactor'

class EditNodeBlurb

  include Lotus::Interactor
  expose :new_document, :error

  def initialize(node_id, blurb_text)
    @node =  NSNodeRepository.find node_id
    @node.meta['long_blurb'] = blurb_text
  end

  def call
    @node.update_blurb
    NSNodeRepository.update @node
  end

end
