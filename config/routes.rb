# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api, module: :api, defaults: { format: :json } do
    resources :announcements, only: [:index, :create, :show] do
      get :active, on: :collection
      put :cancel, on: :member
    end
    resources :responses, only: [:index, :create] do
      put :accept, on: :member
      put :cancel, on: :member
    end
    resources :users, only: :create
  end
end
