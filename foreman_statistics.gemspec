require File.expand_path('lib/foreman_statistics/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'foreman_statistics'
  s.version     = ForemanStatistics::VERSION
  s.license     = 'GPL-3.0'
  s.authors     = ['Ondrej Ezr']
  s.email       = ['oezr@redhat.com']
  s.homepage    = 'https://theforeman.org'
  s.summary     = 'Add Statistics and Trends.'
  # also update locale/gemspec.rb
  s.description = 'Statistics and Trends for Foreman gives users overview of their infrastructure.'

  s.files = Dir['{app,config,db,lib,locale,webpack}/**/*'] + ['LICENSE', 'Rakefile', 'README.md', 'package.json']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rubocop', '~> 0.87.0'
  s.add_development_dependency 'rubocop-minitest', '~> 0.9.0'
  s.add_development_dependency 'rubocop-performance', '~> 1.5.2'
  s.add_development_dependency 'rubocop-rails', '~> 2.5.2'
end
