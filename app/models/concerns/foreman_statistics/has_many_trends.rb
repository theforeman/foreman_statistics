module ForemanStatistics
  module HasManyTrends
    extend ActiveSupport::Concern

    included do
      has_many :trends, as: :trendable, class_name: 'ForemanStatistics::ForemanTrend', dependent: :destroy
    end
  end
end
