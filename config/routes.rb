Rails.application.routes.draw do
  resources :products, only: :buy do
    member do
      post :buy
    end
  end
end
