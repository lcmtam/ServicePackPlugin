Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get 'projects/filterSP', to: 'projects#filterSP'
  resources :projects, only: [:new, :create, :index, :show, :update] do
    resources :time_entries, only: [:new, :create, :index]
    resources :time_entry_activities, only: [:new, :create]
    resources :sp_assignments, only: [:new, :create]
  end
  resources :time_entries, only: [:show, :edit, :update, :destroy]
  resources :time_entry_activities, only: [:edit, :update]
  resources :service_packs, only: [:new, :create, :show]
  resources :sp_assignments, only: [:new, :create]
  
  #default routes
  get '/begone', to: "boots#begone"
  get '/', to: "boots#dummy"
  root "boots#dummy"
end
