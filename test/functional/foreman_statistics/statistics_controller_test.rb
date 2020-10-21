require_relative '../../test_plugin_helper'

module ForemanStatistics
  class StatisticsControllerTest < ActionController::TestCase
    setup do
      @routes = ForemanStatistics::Engine.routes
    end

    test 'user with viewer rights should succeed in viewing statistics' do
      setup_user('view', 'statistics')
      get :index, session: set_session_user(:one)
      assert_response :success
    end

    test 'user with viewer rights should succeed in requesting statistics data via ajax' do
      setup_user('view', 'statistics')
      get :show, params: { :id => 'operatingsystem', :format => 'json' }, session: set_session_user(:one)
      assert_response :success
    end
  end
end
