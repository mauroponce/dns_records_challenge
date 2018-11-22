Rails.application.routes.draw do
  resources :dns_records, only: [:create] do
    collection do
      get :search
    end
  end
end
