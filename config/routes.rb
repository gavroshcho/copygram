Rails.application.routes.draw do
  get 'notifications/link_through'

  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'notifications', to: 'notifications#index'
  resources :posts do
    resources :comments
    member do
      get 'like'
      get 'unlike'
    end
  end
  root "posts#index"
  get ':user_name', to: "profiles#show", as: :profile
  get ':user_name/edit',to: "profiles#edit", as: :edit_profile
  patch ':user_name/edit', to: 'profiles#update', as: :update_profile
  get 'notifications/:id/link_through', to: "notifications#link_through", as: :link_through
  post ':user_name/follow_user', to: "relationships#follow_user", as: :follow_user
  post ':user_name/unfollow_user', to: "relationships#unfollow_user", as: :unfollow_user
end
