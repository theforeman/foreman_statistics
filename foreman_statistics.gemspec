require File.expand_path('../lib/foreman_statistics/version', __FILE__)

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

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
