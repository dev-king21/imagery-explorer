Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :tours, only: %i[index show create update destroy] do
        resources :photos, only: %i[index show create update destroy]
      end

      resources :tourbooks

      resources :users, only: %i[show] do
        collection do
          get 'current_account'
        end

        resources :tourbooks, only: %i[index]
      end

      post '/viewpoints', to: 'photos#set_viewpoints'
      get '/viewpoints', to: 'photos#get_viewpoints'
      get '/users', to: 'users#get_info'

      get '*unmatched_route', to: 'base#user_not_authorized', code: 401
    end
  end

  resources :users, only: %i[show] do
    post 'generate_new_token', to: 'users#generate_new_token'
    get 'tourbooks', to: 'tourbooks#user_tourbooks'

    resources :tours, only: %i[show]

    resources :tourbooks, except: %i[index] do
      member do
        post 'add_item', to: 'tourbooks#add_item'
        delete 'remove_item', to: 'tourbooks#remove_item'
      end
    end
  end

  resources :photos, only: %i[index show] do
    collection do
      get 'viewpoints'
    end
  end

  get '/search_tours', to: 'tours#search_tours'
  get '/sitemap.xml', to: 'application#sitemap'
  get '/robots.txt' => 'robots_txts#show'
  get '/about', to: 'home#about'
  get '/upload', to: 'home#upload'

  root to: 'home#index'

end
