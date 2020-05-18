module ForemanStatistics
  module GeneralSettingDecorations
    def self.prepended(base)
      class << base
        prepend ClassMethodsPrepend
      end
    end

    module ClassMethodsPrepend
      def default_settings
        super.concat([
                       set('max_trend', N_('Max days for Trends graphs'), 30, N_('Max trends'))
                     ])
      end
    end
  end
end
