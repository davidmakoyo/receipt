Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root "collages#show", as: :authenticated_root
  end

  unauthenticated do
    root to: redirect("/users/sign_in"), as: :unauthenticated_root
  end

  get "/my_collage", to: "collages#show", as: :my_collage
  get "/collages/:username", to: "collages#show", as: :user_collage

  get "/tests", to: "tests#index", as: :tests
  get "/tests/:slug", to: "tests#show", as: :test
  post "/tests/:slug/results", to: "test_results#create", as: :test_results

  get "/friends", to: "friends#index", as: :friends
  post "/friends", to: "friends#create"
  delete "/friends/:id", to: "friends#destroy", as: :friend

  get "up" => "rails/health#show", as: :rails_health_check
end
