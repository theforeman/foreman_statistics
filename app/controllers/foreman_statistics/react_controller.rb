module ForemanStatistics
  class ReactController < ::ApplicationController
    layout 'foreman_statistics/layouts/application_react'

    def index
      render html: nil, layout: true
    end

    private

    def controller_permission
      :foreman_statistics
    end

    def action_permission
      :view
    end
  end
end
