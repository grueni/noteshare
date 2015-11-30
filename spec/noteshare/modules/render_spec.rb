  require 'spec_helper'

describe Render do

  before do

    ImageRepository.clear
    image = Image.new(title: 'Shell', url: 's3.amazonaws.com/vschool/noteshare_images/Joordens_Trinil_engravedshell-640x907-original.jpg')
    ImageRepository.create image
    @image = ImageRepository.find_one_by_title('Shell')
    @text = "This ia an image:\n\nimage::#{@image.id}[width=200] \n\nLa di dah!"

    puts '======================'.red
    puts @image.title.magenta
    puts @image.id.to_s.magenta
    puts @image.url.magenta
    puts @text.cyan
    puts '======================'.magenta

  end

=begin
 it 'renders the source given to it' do

   r = Render.new('This is a _test_')
   r.convert.must_include('<em>test</em>')

 end

=end
 it 'rewrites media urlst' do

   r = Render.new(@text)
   out = r.convert
   puts out
   expected_tag = '<img src="http://s3.amazonaws.com/vschool/noteshare_images/Joordens_Trinil_engravedshell-640x907-original.jpg" alt="Joordens Trinil engravedshell 640x907 original" width="200">'
   r.convert.must_include(expected_tag)

   r.delete

 end


end
