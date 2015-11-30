# spec/web/controllers/documents/index_spec.rb
require 'spec_helper'
require_relative '../../../../apps/web/controllers/documents/index'

describe Web::Controllers::Documents::Index do
  let(:action) { Web::Controllers::Documents::Index.new }
  let(:params) { Hash[] }

  before do
    DocumentRepository.clear
    @user = User.create(first_name: 'Kent', last_name: 'Beck', screen_name: 'kbeck', password:'foobar123', password_confirmation:'foobar123')
    @document = NSDocument.create(title: 'TDD', author_credentials: @user.credentials)
  end

  it 'has a valid document for testing' do
    doc = DocumentRepository.find_by_title('TDD').first
    doc.title.must_equal('TDD')
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