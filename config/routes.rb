ForemanStatistics::Engine.routes.draw do
  resources :statistics, :only => %i[index show], constraints: ->(req) { req.format == :json }
  match 'statistics' => 'react#index', :via => :get

  namespace :api, defaults: { format: 'json' } do
    scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v1|v2/, constraints: ApiConstraints.new(version: 2, default: true) do
      resources :trends, :only => %i[create index show destroy]
      resources :statistics, :only => [:index]
    end
  end
end

Foreman::Application.routes.draw do
  mount ForemanStatistics::Engine, at: '/foreman_statistics'
end
