# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

if Rails::VERSION::MAJOR >= 3
  match '/projects/:id/:overview', :to => 'projects#show', :constraints => {:overview => 'overview'}
  match '/:main', :to => 'welcome#index', :constraints => {:main => 'welcome'}
else
  ActionController::Routing::Routes.draw do |map|
    map.connect '/projects/:id/:overview', :controller => 'projects', :action => 'show', :requirements => {:overview => /overview/}
    map.connect '/:main', :controller => 'welcome', :action => 'index', :requirements => {:main => /welcome/}
  end
end