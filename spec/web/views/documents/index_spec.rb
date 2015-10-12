# spec/web/views/documents/index_spec.rb
require 'spec_helper'
require_relative '../../../../apps/web/views/documents/index'

describe Web::Views::Documents::Index do
  let(:exposures) { Hash[documents: []] }
  let(:template)  { Lotus::View::Template.new('apps/web/templates/documents/index.html.haml') }
  let(:view)      { Web::Views::Documents::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #documents" do
    view.documents.must_equal exposures.fetch(:documents)
  end

  describe 'when there are no documents' do
    it 'shows a placeholder message' do
      rendered.must_include("<p class='placeholder'>There are no documents yet.</p>")
    end
  end

  describe 'when there are documents' do
    let(:document1)     { Document.new(title: 'OS Z', author: 'Melvin Foo-Bar') }
    let(:document2)     { Document.new(title: 'Electromagnetic Theory', author: 'Laura Lee') }
    let(:exposures) { Hash[documents: [document1, document2]] }

    it 'lists them all' do
      rendered.scan(/class='document'/).count.must_equal 2
      rendered.must_include('OS Z')
      rendered.must_include('Electromagnetic Theory')
    end

    it 'hides the placeholder message' do
      view.render.wont_include('<p class="placeholder">There are no documents yet.</p>')
    end
  end
end