ActionController::Routing::Routes.draw do |map|
  map.resources :divisions, :only => :index
  map.resources :cities, :only => :index
end