module ForemanStatistics
  module SettingDecorations
    extend ActiveSupport::Concern

    included do
      Setting::NONZERO_ATTRS.push('max_trend')
    end
  end
end
