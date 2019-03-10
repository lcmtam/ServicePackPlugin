Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    #default routes
  get '/begone', to: 'boots#begone'
  get '/', to: 'boots#dummy'
  root 'boots#dummy'
  
  get 'projects/filterSP', to: 'projects#filterSP'
  get 'admin/', to: 'admin#opis'
  get 'admin/index', to: 'admin#index'
  get 'admin/new', to: 'admin#new'
  post 'admin/create', to: 'admin#create'
  get 'admin/tmp', to: 'admin#tmp'


  resources :projects, only: [:new, :create, :index, :show, :update] do
    resources :time_entries, only: [:new, :create, :index]
    resources :time_entry_activities, only: [:new, :create]
    resources :sp_assignments, only: [:new, :create]
    get :edit_activities
    put :update_activities
  end
  resources :time_entries, only: [:show, :edit, :update, :destroy]
  resources :time_entry_activities, only: [:edit, :update]
  resources :service_packs, only: [:new, :create, :show]
  resources :sp_assignments, only: [:new, :create]
  
  mount API::V1::Base, at: '/'
end
