module ForemanStatistics
  class Trend < ApplicationRecord
    self.table_name = 'trends'

    validates_lengths_from_database
    after_save :create_values, :if => ->(o) { o.fact_value.nil? }
    after_destroy :destroy_values, :if => ->(o) { o.fact_value.nil? }

    belongs_to :trendable, :polymorphic => true
    has_many :trend_counters, :dependent => :destroy

    scope :has_value, -> { where('fact_value IS NOT NULL').order('fact_value') }
    scope :types, -> { where(:fact_value => nil) }

    def to_param
      Parameterizable.parameterize("#{id}-#{to_label}")
    end

    def self.title_name
      'label'.freeze
    end

    def self.humanize_class_name(_name = nil)
      super('Trend')
    end

    def self.build_trend(trend_params = {})
      params = trend_params.dup
      params[:trendable_type] = 'ForemanPuppet::Environment' if params[:trendable_type] == 'Environment'
      params[:trendable_type] == 'FactName' ? FactTrend.new(params) : ForemanTrend.new(params)
    end

    private

    def destroy_values(ids = [])
      TrendCounter.where(:trend_id => ids).delete_all
      Trend.where(:id => ids).delete_all
    end
  end
end
