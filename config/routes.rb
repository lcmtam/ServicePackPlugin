Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get 'projects/filterSP', to: 'projects#filterSP'
  resources :projects, only: [:new, :create, :index, :show, :update] do
    resources :time_entries, only: [:new, :create, :index]
  end
  resources :time_entries, only: [:show, :edit, :update, :destroy]
  #default routes
  get '/begone', to: "boots#begone"
  get '/', to: "boots#dummy"
  root "boots#dummy"
end
