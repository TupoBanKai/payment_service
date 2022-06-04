Rails.application.routes.draw do
  resources :products, only: [] do
    member do
      post :buy
    end
  end
end
