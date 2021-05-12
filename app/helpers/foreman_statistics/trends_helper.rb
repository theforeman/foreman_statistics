module ForemanStatistics
  module TrendsHelper
    include ::CommonParametersHelper

    def trendable_types
      options = { _('Environment') => 'Environment', _('Operating system') => 'Operatingsystem',
                  _('Model') => 'Model', _('Facts') => 'FactName', _('Host group') => 'Hostgroup', _('Compute resource') => 'ComputeResource' }
      existing = ForemanTrend.types.pluck(:trendable_type)
      options.delete_if { |_k, v| existing.include?(v) }
    end

    def trend_days_filter(trend)
      form_tag trend, :id => 'days_filter', :method => :get, :class => 'form form-inline' do
        content_tag(:span, (_('Trend of the last %s days.') %
                            select(nil, 'range', 1..Setting[:max_trend], { :selected => trends_range },
                              { :onchange => "$('#days_filter').submit();$(this).attr('disabled','disabled');;" })).html_safe)
      end
    end

    def trend_title(trend)
      if trend.fact_value.blank?
        trend.to_label
      else
        "#{trend.type_name} - #{trend.to_label}"
      end
    end

    ##
    # Returns data in format:
    #
    # [
    #   [time, <time_int>, <time_int>],
    #   [trend_val1, <host_count>, <host_count>],
    #   [trend_val2, 5, 2],
    #   [trend_valx, 213, 3]
    # ]
    def trend_chart_data(trend, from = Setting[:max_trend])
      data = {}
      names = {}
      trend.values.preload(:trendable).each { |value| names[value.id] = CGI.escapeHTML(value.to_label) }
      trend.values.preload(:trend_counters).joins(:trend_counters)
           .where(['trend_counters.interval_end > ? or trend_counters.interval_end is null', from])
           .reorder('trend_counters.interval_start')
           .each do |value|
        value.trend_counters.each do |counter|
          current_data = data[counter.interval_start.to_i] ||= {}
          next_timestamp = counter.try(:interval_end) || Time.now.utc
          next_data = data[next_timestamp.to_i] ||= {}
          current_data[value.id] = next_data[value.id] = counter.count
        end
      end
      times = data.keys.sort
      result = names.map { |id, label| [label].concat(times.map { |time| data[time][id].to_f }) }
      result.unshift(['time'].concat(times))
    end

    def trends_range
      params['range'].empty? ? Setting[:max_trend] : params['range'].to_i
    end
  end
end
