require 'test_statistics_helper'

module ForemanStatistics
  class StatisticsTest < ActiveSupport::TestCase
    def setup
      User.current = users :admin
    end

    test 'it should return list of statistics objects' do
      assert_not_empty Statistics.charts(nil, nil)
    end

    test 'it should include an Operating System stat' do
      os = Statistics.charts(nil, nil).detect { |s| s.id == 'operatingsystem' }
      assert_equal 'operatingsystem', os.id
      data = { :id => 'operatingsystem', :title => 'OS Distribution', :url => '/foreman_statistics/statistics/operatingsystem', :search => '/hosts?search=os_title%3D~VAL~' }
      assert_equal data, os.metadata
    end

    test 'it should set taxonomies as API paramaters according to current context' do
      os = Statistics.charts(taxonomies(:empty_organization).id, nil).detect { |s| s.id == 'operatingsystem' }
      data = { :id => 'operatingsystem', :title => 'OS Distribution', :url => "/foreman_statistics/statistics/operatingsystem?organization_id=#{taxonomies(:empty_organization).id}", :search => '/hosts?search=os_title%3D~VAL~' }
      assert_equal data, os.metadata

      os = Statistics.charts(nil, taxonomies(:location1).id).detect { |s| s.id == 'operatingsystem' }
      data = { :id => 'operatingsystem', :title => 'OS Distribution', :url => "/foreman_statistics/statistics/operatingsystem?location_id=#{taxonomies(:location1).id}", :search => '/hosts?search=os_title%3D~VAL~' }
      assert_equal data, os.metadata

      os = Statistics.charts(taxonomies(:empty_organization).id, taxonomies(:location1).id).detect { |s| s.id == 'operatingsystem' }
      data = { :id => 'operatingsystem', :title => 'OS Distribution', :url => "/foreman_statistics/statistics/operatingsystem?location_id=#{taxonomies(:location1).id}&organization_id=#{taxonomies(:empty_organization).id}", :search => '/hosts?search=os_title%3D~VAL~' }
      assert_equal data, os.metadata
    end

    test 'it should initialize a base statistics object' do
      stat = Statistics::Base.new(:count_by => :hostgroup)
      assert_equal :hostgroup, stat.count_by
      assert_equal 'hostgroup', stat.id
      assert_equal '/foreman_statistics/statistics/hostgroup', stat.url
      assert_raise(NotImplementedError) { stat.calculate }
    end

    test 'it should initialize a fact counter statistics object' do
      stat = Statistics::CountFacts.new(:count_by => 'uptime')
      assert_kind_of Array, stat.calculate
    end

    test 'it should initialize a fact counter statistics object with units' do
      stat = Statistics::CountFacts.new(:count_by => 'uptime', :unit => ['%s core', '%s cores'])
      assert_equal ['%s core', '%s cores'], stat.unit
      assert_kind_of Array, stat.calculate
    end

    describe 'CountHosts' do
      test 'initializes a host counter statistics object' do
        stat = Statistics::CountHosts.new(:count_by => :compute_resource)
        assert_kind_of Array, stat.calculate
      end

      test 'calculates stats by given metric' do
        host = FactoryBot.create(:host, :with_operatingsystem)
        stat = Statistics::CountHosts.new(count_by: :operatingsystem, title: 'OS Distribution').calculate
        _(stat).must_be_instance_of(Array)
        _(stat.first[:data]).must_equal(1)
        _(stat.first[:label]).must_equal(host.operatingsystem.to_label)
      end
    end

    context 'with puppet plugin' do
      test 'it should fail to calculate a puppet class counter statistics object without an id' do
        skip('no puppet plugin') unless Foreman::Plugin.find(:foreman_puppet)
        assert_raise(ArgumentError) { Statistics::CountPuppetClasses.new }
      end

      test 'it should initialize a puppet class counter statistics object' do
        skip('no puppet plugin') unless Foreman::Plugin.find(:foreman_puppet)
        stat = Statistics::CountPuppetClasses.new(:id => :classes)
        assert_equal '/foreman_statistics/statistics/classes', stat.url
        assert_kind_of Array, stat.calculate
      end
    end

    test 'it should fail to calculate a Fact class counter statistics object without count_by' do
      assert_raise(ArgumentError) { Statistics::CountNumericalFactPair.new }
    end

    test 'it should initialize a fact pair counter statistics object' do
      stat = Statistics::CountNumericalFactPair.new(:count_by => :memory)
      assert_equal 'memorysize', stat.send(:total_name)
      assert_equal 'memoryfree', stat.send(:used_name)
      calc = stat.calculate
      assert_kind_of Array, calc
      assert_equal 'free memory', calc[0][:label]
      assert_equal 'used memory', calc[1][:label]
    end
  end
end
