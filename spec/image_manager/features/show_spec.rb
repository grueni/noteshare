
require 'features_helper'
include FeatureHelpers::Common

describe 'Show image' do

  before do
    skip
    ImageRepository.clear
    @image = Image.new(title: 'Foo', dict: {})
    ImageRepository.create(@image)
  end


  it 'has a valid image for testing 111' do
    image = ImageRepository.first
    image.title.must_equal('Foo')
    puts "/image_manager/show/#{image.id}".red
  end


  it 'cannot visit the page if not logged in 222' do

    skip

    image = ImageRepository.first
    puts "/image_manager/show/#{image.id}".cyan

    visit "/image_manager/show/#{image.id}"
    # assert_match /input name="source"/, page.body, "Expected to find input element of form"
    assert_match /Unauthorized/, page.body, "Expected to find input element of form"

  end

  it 'can visit the page if logged in 333' do

    skip

    image = ImageRepository.first
    puts "/image_manager/show/#{image.id}".cyan

    standard_user_node_doc
    login_standard_user

    visit2 @user, "/image_manager/show/#{image.id}"
    assert_match /input name="source"/, page.body, "Expected to find input element of form"


  end


end
