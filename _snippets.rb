
#USER
@user = User.create(first_name: 'Jared', last_name: 'Foo-Bar', screen_name: 'jayfoo',
                     password: 'foobar123', password_confirmation: 'foobar123')
#DOCUMENT
@document = NSDocument.create(title: 'Test', author_credentials: @user.credentials)