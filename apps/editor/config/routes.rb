get '/status/:id', to: 'document#editor_status'
post '/status/:id', to: 'document#editor_status'
get '/manage_publications/:id', to: 'document#manage_publications'
post '/do_add_pdf', to: 'document#do_add_pdf'
get '/add_pdf/:id', to: 'document#add_pdf'

get '/get/:id', to: 'document#get_file'
get '/put/:id', to: 'document#send_file'
get '/publish_all/:id', to: 'document#publish_all'
get '/publish_section/:id', to: 'document#publish_section'

get '/move/:id', to: 'document#move'

post '/update_toc/:id', to: 'document#update_toc'
get '/edit_toc/:id', to: 'document#edit_toc'

get '/test', to: 'test#toc'

post '/create_new_associated_document', to: 'document#create_new_associated_document'
get '/new_associated_document/:id', to: 'document#new_associated_document'

post '/create_new_section', to: 'document#create_new_section'
get '/new_section/:id', to: 'document#new_section'

post '/json_update/:ipd', to: 'document#json_update'
get '/export/:id', to: 'document#export'

get '/prepare_to_delete_document/:id', to: 'document#prepare_to_delete'
post '/delete_document/:id', to: 'document#delete_document'


# Configure your routes here
# See: http://www.rubydoc.info/gems/lotus-router/#Usage

get '/', to: 'home#index'
get '/new', to: 'documents#new'
get '/new/:id', to: 'documents#new'
get '/documents', to: 'documents#index'
post '/documents', to: 'documents#create'
get '/document/:id', to: 'document#edit'
post '/update', to: 'document#update'
get '/document/options/:id', to: 'document#options'
post '/update_options/', to: 'document#update_options'