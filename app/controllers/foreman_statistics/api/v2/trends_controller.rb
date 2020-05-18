module ForemanStatistics
  module Api
    module V2
      class TrendsController < ::Api::V2::BaseController
        include ForemanStatistics::Parameters::Trend

        before_action :find_resource, :only => %i[show destroy]

        TRENDABLE_TYPES = %w[
          Environment Operatingsystem Model FactName Hostgroup
          ComputeResource
        ].freeze

        resource_description do
          api_version 'v2'
          api_base_url '/foreman_statistics/api'
        end

        api :GET, '/trends/', N_('List of trends counters')
        def index
          @trends = resource_scope_for_index
        end

        api :GET, '/trends/:id/', N_('Show a trend')
        param :id, :identifier, :required => true
        def show; end

        api :POST, '/trends/', N_('Create a trend counter')
        param :trendable_type, TRENDABLE_TYPES, :required => true
        param :fact_name, String, :required => false
        param :name, String, :required => false
        def create
          @trend = ForemanStatistics::Trend.build_trend(trend_params)
          if @trend.save
            process_success
          else
            process_resource_error
          end
        end

        api :DELETE, '/trends/:id/', N_('Delete a trend counter')
        param :id, :identifier, :required => true
        def destroy
          process_response @trend.destroy
        end

        # Overload this method to avoid using search_for method
        def resource_scope_for_index(options = {})
          resource_scope(options).paginate(paginate_options)
        end

        def resource_scope(options = {})
          @resource_scope ||= scope_for(ForemanStatistics::Trend.types, options)
        end
      end
    end
  end
end
