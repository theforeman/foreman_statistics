module ForemanStatistics
  class TrendCounterJob < ApplicationJob
    def perform(options = {})
      start_time = Time.zone.now
      ForemanStatistics::TrendImporter.update!
    ensure
      duration = start_time.is_a?(Time) ? Time.zone.now - start_time : 0
      self.class.set(wait: [30.minutes - duration, 0].max).perform_later(options)
    end

    rescue_from(StandardError) do |error|
      Foreman::Logging.logger('background').error(
        'Trend Counter Job: '\
        "Error while creating new data #{error.message}"
      )
      raise error # propagate the error to the tasking system to properly report it there
    end

    def humanized_name
      _('Trend Counter Job')
    end
  end
end
