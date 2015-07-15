Rails.application.routes.draw do
  get 'bestroute/:name/:origin/:destiny/:autonomy/:price' => 'maps#best_route', :constraints => { :autonomy => /[^\/]+/ }
  match "/maps" => "maps#create", :via => :post, :defaults => { :format => :json }
end
