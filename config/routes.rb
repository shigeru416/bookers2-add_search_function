Rails.application.routes.draw do
  
  root 'home#top'
  get 'home/about'
  devise_for :users
  resources :users
  get 'users/:id/follows'=> 'users#follows', as: 'follows'
  get 'users/:id/followers'=> 'users#followers', as: 'followers'
  
  resources :books do
   resource :book_comments, only:[:create, :destroy]
   resource :favorites, only: [:create, :destroy]
  end

  post 'follow/:id' => 'relationships#create', as: 'follow' # フォローする
  post 'unfollow/:id' => 'relationships#destroy', as: 'unfollow' # フォロー外す
  
  get 'searchs/search'

end