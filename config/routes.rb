Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root to: 'comments#index'
  resources :comments, only: [:index, :create, :update]
  resource :user, only: [] do
    get   :show,   on: :collection
    patch :update, on: :collection
  end
end
