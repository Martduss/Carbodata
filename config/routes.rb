Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "pages#root"
  get "home", to: "pages#home"
  get "feed", to: "pages#feed"
  get "profile", to: "pages#profile"
  get "privacy-policy", to: "pages#privacy_policy"
  post "demo_login", to: "demo_sessions#create", as: :demo_login
  delete "demo_logout", to: "demo_sessions#destroy", as: :demo_logout

  resources :posts do
    resources :comments, except: [:show, :index, :edit] do
      resource :vote, only: [:create]
    end
    resource :vote, only: [:create]
  end

  resources :users, only: [:show]
  resources :recipes
  resources :items, except:[:new]
  resources :chats, only: [:index, :show, :destroy] do
    resources :messages, only: [:create] do
      member do
        post :save_recipe
      end
    end
  end
  resources :chat_items, only: [:new, :create]
end
