Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root "dashboard#show", as: :authenticated_root
  end

  unauthenticated do
    root to: redirect("/users/sign_in"), as: :unauthenticated_root
  end

  get "/dashboard", to: "dashboard#show", as: :dashboard
  resources :receipts do
    collection do
      get :claim_report
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
