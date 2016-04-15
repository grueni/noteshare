require 'spec_helper'
require_relative '../../../lib/noteshare/interactors/viewer/print_manager'
require_relative '../../features_helper'
require 'pry'

include FeatureHelpers::Common

include Noteshare::Interactor::Document
include ::Noteshare::Core::Document
include Noteshare::Core::Node


describe PrintManager do

  before do

    standard_user_node_doc

  end

  it 'has a document to test' do

    assert @document.title == 'Test'
    assert @document.content =~ /== Introduction/

  end

  it 'can process a document' do

    printer = PrintManager.new(document_id: @document.id, option: 'section')
    result = printer.call
    assert result.html.include?('This <em>is</em> a test:')  , 'The html output is as expected'

  end

end