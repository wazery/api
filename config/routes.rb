# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".
require 'sidekiq/web'

Rails.application.routes.draw do
  apipie

  root to: 'misc#ping'

  scope :api do
    resources :hackers, only: [:show, :update]
    resource :sessions, only: [:create, :show, :destroy]
    get 'private_access_callback', to: 'sessions#private_access_callback'
    mount Sidekiq::Web, at: '/sidekiq'
  end
end
