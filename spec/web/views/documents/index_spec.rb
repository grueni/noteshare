# spec/web/views/documents/index_spec.rb
require 'spec_helper'
require_relative '../../../../apps/web/views/documents/index'

describe Web::Views::Documents::Index do

  let(:exposures) { Hash[documents: [], nodes: []] }
  let(:template)  { Lotus::View::Template.new('apps/web/templates/documents/index.html.slim') }
  let(:view)      { Web::Views::Documents::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #documents" do
    view.documents.must_equal exposures.fetch(:documents)
  end

  describe 'when there are no documents' do

  end

  describe 'when there are documents' do

    let(:document1)     { NSDocument.new(title: 'OS Z', author: 'Melvin Foo-Bar') }
    let(:document2)     { NSDocument.new(title: 'Electromagnetic Theory', author: 'Laura Lee') }


    let(:exposures) { Hash[documents: [document1, document2], nodes: []] }

    it 'lists them all' do

      skip

      # rendered.scan(/class='document'/).count.must_equal 2
      rendered.must_include('OS Z')
      rendered.must_include('Electromagnetic Theory')
    end


  end
end