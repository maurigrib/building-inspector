Webappmini::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users
  resources :sheets
  resources :flags
  resources :polygons

  # embeddable widgets!
  get "/widgets/map/:map_id", to: "widgets#map"

  # legacy urls
  get "/building", to: "general#home"

  ### custom admin routes

  # flag listing
  get "/flags/all/:type", to: "flags#all"

  # for session checking
  get "cookie_test", :controller => :general

  #random map provider url
  get "fixer/map", to: "fixer#randomMap"

  # admin specials
  get "polygon_consensus", to: "polygons#consensus"
  get "flag_progress", to: "flags#progress"

  # general content stuff
  get "general/home", :as => "home"
  get "general/about", :as => "about"
  get "general/help", :as => "help"
  get "general/data", :as => "data"
  get "general/win", :as => "win"

  # footprints
  # this uses a different route as the task name for user friendliness purposes
  get "footprint", to: "fixer#geometry", :as => "geometry"
  get "footprint/progress", to: "fixer#progress_geometry", :as => "geometry_progress"
  get "footprint/progress_all", to: "fixer#progress_geometry_all", :as => "geometry_progress_all"

  # footprints progress json endpoints
  get "geometry/progress_user", to: "fixer#session_progress_geometry_for_sheet"
  get "geometry/progress_sheet", to: "fixer#progress_sheet_geometry"

  # addresses
  get "address", to: "fixer#address", :as => "address"
  get "address/progress", to: "fixer#progress_address", :as => "address_progress"
  get "address/progress_all", to: "fixer#progress_address_all", :as => "address_progress_all"

  # address progress json endpoints
  get "address/progress_user", to: "fixer#session_progress_address_for_sheet"
  # TODO: progrees for sheet (requires consensus)

  # polygonfix
  # this uses a different route as the task name for user friendliness purposes
  get "fix", to: "fixer#polygonfix", :as => "polygonfix"
  get "fix/progress", to: "fixer#progress_polygonfix", :as => "polygonfix_progress"

  # polygonfix progress json endpoints
  get "polygonfix/progress_user", to: "fixer#session_progress_polygonfix_for_sheet"
  # TODO: progrees for sheet (requires consensus)

  # colors
  get "color", to: "fixer#color", :as => "color"
  get "color/progress", to: "fixer#progress_color", :as => "color_progress"
  get "color/progress_all", to: "fixer#progress_color_all", :as => "color_progress_all"

  # colors progress json endpoints
  get "color/progress_user", to: "fixer#session_progress_color_for_sheet"
  get "color/progress_sheet", to: "fixer#progress_sheet_color"

  # json flagging
  post "fixer/flag", to: "fixer#apply_flags_to_polygon"

  # api endpoints
  get "api/polygons"
  get "api/polygons/:task", to: "api#polygons"
  get "api/polygons/:task/page/:page", to: "api#polygons"
  get "api/polygons/:task/:consensus", to: "api#polygons"
  get "api/polygons/:task/:consensus/page/:page", to: "api#polygons"
  get "api/polygons_for_ids", to: "api#polygons_for_ids"
  get "api/consolidated"
  get "api/consolidated/page/:page", to: "api#consolidated"

  match "/404", :to => "general#not_found", :status => 404

  # get "homenew" => "general#home"

  root :to => "general#home"
end
