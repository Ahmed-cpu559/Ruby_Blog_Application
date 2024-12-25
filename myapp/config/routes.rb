Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  resources :posts
  post 'auth/signup', to: 'user#register'
  post 'auth/login', to: 'user#login'
  post 'auth/post', to: 'posts#create'
  delete 'auth/post/:id', to: 'posts#destroy' 
  put 'auth/post/:id', to: 'posts#update' 
  
  put 'auth/tag_post/:post_id/:tag_id', to: 'posts#update_tag' 


  post 'auth/comment/:post_id', to: 'comments#create'
  delete 'auth/comment/:comment_id', to: 'comments#destroy' 
  put 'auth/comment/:comment_id', to: 'comments#update' 


#   get 'tags', to: 'tags#index'
# get 'tags/:id', to: 'tags#show'
# post 'tags', to: 'tags#create'
# put 'tags/:id', to: 'tags#update'
# delete 'tags/:id', to: 'tags#destroy'
  # delete "auth/delete/:id", to: "posts#destroy"

  # post 'auth/posts/:post_id/comments', to: 'comments#create'  
  # delete 'auth/posts/:post_id/comments/:id', to: 'comments#destroy'  

  # put 'auth/posts/:post_id/update_tags', to: 'posts#update_tags'  


  root 'home#index'

  

  # Defines the root path route ("/")
  # root "posts#index"
end
