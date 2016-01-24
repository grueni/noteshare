
require 'features_helper'

describe 'Show image' do

  before do
    ImageRepository.clear
    @image = Image.new(title: 'Foo', dict: {})
    ImageRepository.create(@image)
  end


  it 'has a valid image for testing' do
    image = ImageRepository.first
    image.title.must_equal('Foo')
    puts "/image_manager/show/#{image.id}".red
  end


  it 'can visit the page' do

    image = ImageRepository.first
    puts "/image_manager/show/#{image.id}".cyan

    visit "/image_manager/show/#{image.id}"
    assert_match /input name="source"/, page.body, "Expected to find input element of form"

  end


end
