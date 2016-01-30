  require 'spec_helper'

describe Render do

  before do

    ImageRepository.clear
    image = Image.new(title: 'Shell', dict: {}, file_name: 'Joordens_Trinil_engravedshell-640x907-original.jpg', url: 'http://s3.amazonaws.com/vschool/noteshare_images/Joordens_Trinil_engravedshell-640x907-original.jpg')

    ImageRepository.create image
    @image = ImageRepository.find_one_by_title('Shell')
    @text = "This ia an image:\n\nimage::#{@image.id}[width=200] \n\nLa di dah!"

  end


 it 'renders the source given to it' do

   r = Render.new('This is a _test_')
   r.convert.must_include('<em>test</em>')

 end

 it 'rewrites media urls' do

   rendered_text = Render.new(@text).convert
   assert rendered_text.include?("http://s3.amazonaws.com/vschool/noteshare_images/Joordens_Trinil_engravedshell-640x907-original.jpg"), "image url present in rendered text"

 end


end
