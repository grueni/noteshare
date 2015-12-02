require 'spec_helper'

require 'json'

# The tests below are mainly concerned with
# setting and persisting attributes
describe NSDocument do








  #### COMPILATION


  #### DELETION




  it 'can add recall associated documents ass' do

    notes = DocumentRepository.create(NSDocument.new(title: 'Tables', author: 'Jared. Foo-Bar'))
    notes.associate_to(@article, 'notes')
    puts "@article.doc_refs: #{@article.doc_refs}"
    @article.associated_document('notes').must_equal notes

  end








end
