Rails.application.routes.draw do
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

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      member do
        post :select_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  resources :comments, only: :create

  mount ActionCable.server => '/cable'
end
