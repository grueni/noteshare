# spec/web/controllers/documents/index_spec.rb
require 'spec_helper'
require_relative '../../../../apps/web/controllers/documents/index'

describe Web::Controllers::Documents::Index do
  let(:action) { Web::Controllers::Documents::Index.new }
  let(:params) { Hash[] }

  before do
    DocumentRepository.clear

    @document = DocumentRepository.create(NSDocument.new(title: 'TDD', author: 'Kent Beck'))
  end

  it "is successful" do
    response = action.call(params)
    response[0].must_equal 200
  end

  it 'exposes all documents' do
    action.call(params)
    skip action.exposures[:documents].must_equal [@document]
    action.exposures[:documents][0].title.must_equal @document.title
  end
end