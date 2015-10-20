# spec/web/views/books/index_spec.rb
=begin
require 'spec_helper'
require_relative '../../../../apps/web/views/documents/show'

describe Web::Views::Document::Show do
  let(:exposures) { Hash[document: []] }
  let(:template)  { Lotus::View::Template.new('apps/web/templates/documents/show.html.erb') }
  let(:view)      { Web::Views::NSDocument::Show.new(template, exposures) }
  let(:rendered)  { view.render }

  it "exposes #document" do
    view.document.must_equal exposures.fetch(:document)
  end

  describe 'when there is no document' do
    it 'shows a placeholder message' do
      rendered.must_include('<p class="placeholder">There are no documents yet.</p>')
    end
  end

  describe 'when there is a document' do
    let(:document)     { Docuemnt.new(title: 'Refactoring', author: 'Martin Fowler') }
    let(:exposures) { Hash[boo: [document1]] }

    it 'shows the document' do
      rendered.scan(/class="nsdocument"/).count.must_equal 1
      rendered.must_include('Refactoring')
    end

    it 'hides the placeholder message' do
      view.render.wont_include('<p class="placeholder">There is no document yet.</p>')
    end
  end
end
=end