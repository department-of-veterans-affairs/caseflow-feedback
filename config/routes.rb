Rails.application.routes.draw do
 
 resource :feedback

 root 'feedback#new'
 
end
