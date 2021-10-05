Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :confirmations => 'users/confirmations',
    :passwords => 'users/passwords',
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
    :unlocks => 'users/unlocks'
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get 'products/index' => 'products#index'
  get '/' => 'home#index'

end
