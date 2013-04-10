Rails.application.routes.draw do
  match 'projects/:project_id/project_extras/:action', :to => 'project_extras'
  match 'project_extras/preview', :to => 'project_extras#preview',:via => [:get, :post]
  match 'project_extras/add_status_message', :to => 'project_extras#add_status_message',:via => [:get, :post]
end
