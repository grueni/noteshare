post '/do_image_upload', to: 'image#do_upload'
get '/image', to: 'image#upload'

post '/do_upload', to: 'file#do_upload'
get '/file', to: 'file#upload'

# Configure your routes here
# See: http://www.rubydoc.info/gems/lotus-router/#Usage