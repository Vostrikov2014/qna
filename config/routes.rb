require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  devise_scope :user do
    post 'custom_email', to: 'oauth_callbacks#custom_email'
  end

  concern :votable do
    member do
      post :up
      post :down
      post :cancel_vote
    end
  end

  concern :rateable do
    member do
      patch :rate_up
      patch :rate_down
      delete :cancel_vote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      member do
        post :select_best
      end
    end
    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  resources :comments, only: :create

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end

  #get 'search', to: "search#search"
  get 'search', to: 'search#index'
end
