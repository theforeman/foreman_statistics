module ForemanStatistics
  class StatisticsController < ::ApplicationController
    before_action :find_stat, :only => [:show]

    def index
      render :json => { :charts => charts.map(&:metadata) }
    end

    def show
      render :json => @stat.metadata.merge(:data => @stat.calculate.map(&:values))
    end

    private

    def find_stat
      @stat = charts.detect { |ch| ch.id.to_s == params[:id] }
      @stat || not_found
    end

    def charts
      ForemanStatistics::Statistics.charts(Organization.current.try(:id), Location.current.try(:id))
    end
  end
end
