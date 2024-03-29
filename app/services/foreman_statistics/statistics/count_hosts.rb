module ForemanStatistics
  module Statistics
    class CountHosts < Base
      def calculate
        count_distribution(Host.authorized(:view_hosts, Host), count_by)
      end

      private

      def count_distribution(scope, association)
        case association.to_sym
        when :environment
          klass = ForemanPuppet::Environment
          scope = scope.joins(:puppet)
          grouping = ForemanPuppet::HostPuppetFacet.arel_table[:environment_id]
        else
          klass = association.to_s.camelize.constantize
          grouping = Host::Managed.arel_table["#{association}_id"]
        end

        output = []
        data = scope.reorder('').group(grouping).count
        associations = klass.where(id: data.keys).to_a
        data.each do |k, v|
          output << { label: associations.detect { |a| a.id == k }.to_label, data: v } unless v.zero?
        rescue StandardError => e
          Rails.logger.info "skipped '#{association} - #{k}' as it has has no label"
          Rails.logger.debug e
        end
        output
      end
    end
  end
end
