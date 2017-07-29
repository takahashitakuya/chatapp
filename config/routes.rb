Rails.application.routes.draw do
  get 'chats' => 'chats#index'
 post 'chats' => 'chats#create'
 delete 'chats' => 'chats#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
