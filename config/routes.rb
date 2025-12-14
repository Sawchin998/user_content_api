# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: %i[registrations sessions] # Skip default routes
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_scope :user do
        post 'users/signup', to: 'users/registrations#create'
        post 'auth/signin',  to: 'users/sessions#create'
      end

      resources :contents
    end
  end
  # Defines the root path route ("/")
  root 'welcome#index'
end
