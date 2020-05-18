require 'rake/testtask'

# Tasks
namespace :foreman_statistics do
  namespace :trends do
    desc 'Create Trend counts'
    task :counter => :environment do
      ForemanStatistics::TrendImporter.update!
    end

    desc 'Reduces amount of points for each trend group'
    task :reduce => :environment do
      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      trends = ForemanStatistics::Trend.pluck(:id)
      trends_count = trends.length
      current_record = 0

      trends.each do |trend_id|
        puts "Working on trend_id #{trend_id}, #{(current_record += 1)} of #{trends_count}" unless Rails.env.test?

        current_interval = ForemanStatistics::TrendCounter.where(trend_id: trend_id).order(:created_at).first
        next if current_interval.nil?

        current_interval.interval_start = current_interval.created_at
        while (next_interval = ForemanStatistics::TrendCounter.where(trend_id: trend_id)
                                           .where('created_at > ? and count <> ?', current_interval.created_at, current_interval.count)
                                           .order(:created_at).first)
          current_interval.interval_end = next_interval.created_at
          current_interval.save!
          current_interval = next_interval
          current_interval.interval_start = current_interval.created_at
        end
        current_interval.save!
      end

      ForemanStatistics::TrendCounter.unscoped.where(interval_start: nil).delete_all

      puts "It took #{Process.clock_gettime(Process::CLOCK_MONOTONIC) - start} seconds to complete" unless Rails.env.test?
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanStatistics'
  Rake::TestTask.new(:foreman_statistics) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_statistics do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_statistics) do |task|
        task.patterns = ["#{ForemanStatistics::Engine.root}/app/**/*.rb",
                         "#{ForemanStatistics::Engine.root}/lib/**/*.rb",
                         "#{ForemanStatistics::Engine.root}/test/**/*.rb"]
      end
    rescue StandardError
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_statistics'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_statistics']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_statistics', 'foreman_statistics:rubocop']
end
