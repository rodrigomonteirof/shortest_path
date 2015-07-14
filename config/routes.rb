Rails.application.routes.draw do
  get 'bestroute/:name/:origin/:destiny/:autonomy/:price' => 'maps#best_route', :constraints => { :autonomy => /[^\/]+/ }
  resources :maps, :defaults => { :format => :json }
end
