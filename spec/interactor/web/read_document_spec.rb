require 'spec_helper'
require_relative '../../features_helper'
require_relative '../../../lib/noteshare/interactors/editor/read_document'
require 'pry'

include Noteshare::Interactor::Document
include ::Noteshare::Core::Document
include Noteshare::Core::Node



describe ReadDocument do

  before do

    @user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', email: 'jayfoo@bar.com',
                        screen_name: 'jayfoo', password: 'foobar123', password_confirmation: 'foobar123')
    NSNode.create_for_user(@user)
    @document = NSDocument.create(title: 'Test', author_credentials: @user.credentials)
    @document.acl_set_permissions('rw', 'r', 'r')
    @document.content = "== Introduction\n\nThis is a _test_: $a^2 + b^2 = c^2$"
    DocumentRepository.update @document

    @rendered_text = <<EOF
<div class="sect1">
<h2 id="_introduction">Introduction</h2>
<div class="sectionbody">
<div class="paragraph">
<p>This is a <em>test</em>: \\(a^2 + b^2 = c^2\\)</p>
</div>
</div>
</div>
EOF

  end

  it 'can blah blah' do

    hash = { 'id' => @document.id }

    @payload = ReadDocument.new(hash, @user, 'aside').call
    puts @payload.document.rendered_content.cyan
    @payload.document.rendered_content.strip.must_equal @rendered_text.strip


  end


end