Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'home#index'

  # resources :promotions, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
  resources :promotions do
    post 'generate_coupons', on: :member
    get 'search', on: :collection
  end

  resources :coupons, only: [] do
    post 'disable', on: :member
    post 'active', on: :member
  end

  resources :product_categories
end
