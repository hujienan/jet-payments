Rails.application.routes.draw do
  root "payments#index"
  post "/payments", to: "payments#create"
  get "/payments/:id", to: "payments#show"
end
