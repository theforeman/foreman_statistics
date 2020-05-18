require_relative '../../test_plugin_helper'

module ForemanStatistics
  class StatisticsControllerTest < ActionController::TestCase
    setup do
      @routes = ForemanStatistics::Engine.routes
    end

    test 'user with viewer rights should succeed in viewing statistics' do
      @request.session[:user] = users(:one).id
      users(:one).roles = [Role.default, Role.find_by(name: 'Viewer')]
      get :index, session: set_session_user
      assert_response :success
    end

    test 'user with viewer rights should succeed in requesting statistics data via ajax' do
      @request.session[:user] = users(:one).id
      users(:one).roles = [Role.default, Role.find_by(name: 'Viewer')]
      get :show, params: { :id => 'operatingsystem', :format => 'json' }, session: set_session_user
      assert_response :success
    end
  end
end
