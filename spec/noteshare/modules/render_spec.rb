require 'spec_helper'

describe NSNode do



 it 'renders the source given to it' do

   r = Render.new('This is a _test_')
   r.convert.must_include('<em>test</em>')

 end

 it 'rewrites media urlst' do

   r = Render.new("This ia an image:\n\nimage::403[width=200] \n\nLa di dah!")
   out = r.convert
   puts out
   expected_tag = '<img src="http://s3.amazonaws.com/vschool/noteshare_images/Joordens_Trinil_engravedshell-640x907-original.jpg" alt="Joordens Trinil engravedshell 640x907 original" width="200">'
   r.convert.must_include(expected_tag)

   r.delete

 end


end
