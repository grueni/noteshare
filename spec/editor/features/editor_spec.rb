require 'features_helper'
include FeatureHelpers::Session
include  FeatureHelpers::Common

describe 'Editor' do


  before do

    UserRepository.clear
    NSNodeRepository.clear
    DocumentRepository.clear

    standard_user_node_doc
    login_standard_user

  end

  it 'can accept edits and render them' do

    @document.title.must_equal('Test')
    doc2 = DocumentRepository.find @document.id
    doc2.title.must_equal(@document.title)



  end

end