require 'rake/testtask'

# Tasks
namespace :foreman_statistics do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
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
