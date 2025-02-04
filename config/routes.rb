Rails.application.routes.draw do

  root 'welcome#index'
  get '/welcome', to: 'welcome#index'
  get '/merchants/:id/dashboard', to: 'merchants#show'

  get '/merchants/:id/discounts/new', to: 'merchant_discounts#new'
  post 'merchants/:id/discounts', to: 'merchant_discounts#create'

  get '/merchants/:id/discounts', to: 'merchant_discounts#index'
  get '/merchants/:id/discounts/:discount_id', to: 'merchant_discounts#show'
  delete '/merchants/:id/discounts/:discount_id', to: 'merchant_discounts#destroy'
  get '/merchants/:id/discounts/:discount_id/edit', to: 'merchant_discounts#edit'
  patch '/merchants/:id/discounts/:discount_id', to: 'merchant_discounts#update'

  resources :merchants, except: [:show] do
    resources :items, controller: :merchant_items
    resources :invoices, controller: :merchant_invoices
    resources :invoice_items, controller: :merchant_invoice_items
  end

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants
    resources :invoices
  end
end
