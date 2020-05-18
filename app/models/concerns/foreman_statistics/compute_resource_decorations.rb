module ForemanStatistics
  module ComputeResourceDecorations
    extend ActiveSupport::Concern

    included do
      has_many :trends, :as => :trendable, :class_name => "ForemanStatistics::ForemanTrend"
    end
  end
end
