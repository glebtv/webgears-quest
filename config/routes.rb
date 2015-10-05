Rails.application.routes.draw do
  get 'main/index', as: 'logs'

  post 'main/index', to: 'main#create'
  patch 'main/index/:id', to: 'main#update'

  get '/main/index/:id', to: 'main#show', as: 'log'
  get 'main/index/:id/regexp_sort', to: 'main#regexp_sort'


  root 'main#index'

end
