module ForemanStatistics
  module Statistics
    class CountPuppetClasses < Base
      def initialize(options = {})
        super(options)
        if id.empty?
          raise(ArgumentError, 'Must provide an :id or :count_by option')
        end
      end

      def calculate
        ForemanPuppet::Puppetclass.authorized(:view_puppetclasses).map do |pc|
          count = pc.hosts_count
          next if count.zero?
          {
            :label => pc.to_label,
            :data => count
          }
        end.compact
      end
    end
  end
end
