=begin
#USER
@user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo',
                     password: 'foobar123', password_confirmation: 'foobar123')
#DOCUMENT
@document = NSDocument.create(title: 'Test', author_credentials: @user.credentials)

#FORM (SLIM)
.col style='left:50%; width: 50%'
               .div style='max-width:400px; margin-left:2em;'
p== "Image ID: #{image.id}"
        .edit_form
form[name="edit_image" action="update"]

label[name="title" value="Title"] Title
input[type="text" name="title" value="#{image.title}"]

label[name="tags"] Tags
input[type="text" name="tags" value="#{image.tags}"]

label[name="source"] Source
input[type="text" name="source" value="#{image.source}"]

br
br
input[type="submit" name="update" style="background:green"]

#FORM (RUBY)

def form
  puts ">> form NEW Image".red

  form_for :image, '/image_manager/upload', class: 'image new' do

    label :title
    text_field :title

    label :file_name
    text_field :file_name

    submit 'Create image',  class: "waves-effect waves-light btn"

  end
=end
