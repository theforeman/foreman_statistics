require_relative '../../../../test_plugin_helper'

class ForemanStatistics::Api::V2::TrendsControllerTest < ActionController::TestCase
  setup do
    @routes = ForemanStatistics::Engine.routes

    FactoryBot.create(:fact_value, :value => '2.6.9', :host => host,
                                   :fact_name => FactoryBot.create(:fact_name, :name => 'kernelversion'))
  end

  let(:host) { FactoryBot.create(:host) }
  let(:foreman_trend) { FactoryBot.create(:foreman_statistics_foreman_trend, :trendable_type => 'Environment', :fact_name => 'fact') }
  let(:fact_trend) { FactoryBot.create(:foreman_statistics_fact_trend, :trendable_type => 'FactName') }
  let(:os_fact) do
    FactoryBot.create(:fact_value, :value => 'fedora', :host => host,
                                   :fact_name => FactoryBot.create(:fact_name, :name => 'operatingsystem'))
  end
  let(:foreman_trend_invalid_attrs) { { :trendable_type => 'NotExists' } }
  let(:fact_trend_valid_attrs) { { :trendable_type => 'FactName', :trendable_id => os_fact.fact_name_id.to_s } }

  test 'should get index' do
    expected = [foreman_trend.fact_name, fact_trend.fact_name]
    get :index, params: {}
    assert_response :success
    assert_not_nil assigns(:trends)
    trends = ActiveSupport::JSON.decode(@response.body)
    assert_equal expected.sort, trends['results'].map { |t| t['fact_name'] }.sort
  end

  test 'should create a valid foreman trend' do
    foreman_trend; fact_trend; os_fact
    assert_difference('ForemanStatistics::Trend.types.where(:type => "ForemanStatistics::ForemanTrend").count', 1) do
      post :create, params: { :trend => { :trendable_type => 'Model' } }
      assert_response :created
      result = ActiveSupport::JSON.decode(@response.body)
      assert_equal('Model', result['trendable_type'])
      assert_equal('ForemanStatistics::ForemanTrend', result['type'])
    end
  end

  test 'should create a valid fact trend' do
    assert_difference('ForemanStatistics::Trend.types.where(:type => "ForemanStatistics::FactTrend").count', 1) do
      post :create, params: { :trend => fact_trend_valid_attrs }
      assert_response :created
      result = ActiveSupport::JSON.decode(@response.body)
      assert_equal('FactName', result['trendable_type'])
      assert_equal('operatingsystem', result['fact_name'])
      assert_equal('ForemanStatistics::FactTrend', result['type'])
    end
  end

  test 'should not create invalid trends' do
    assert_no_difference('ForemanStatistics::Trend.types.count') do
      post :create, params: { :trend => foreman_trend_invalid_attrs }
    end
    assert_response :error
  end

  test 'should show individual record' do
    get :show, params: { :id => foreman_trend.id.to_param }
    assert_response :success
    show_response = ActiveSupport::JSON.decode(@response.body)
    assert_equal foreman_trend.trendable_type, show_response['trendable_type']
  end

  test 'should destroy trends ' do
    foreman_trend; fact_trend
    assert_difference('ForemanStatistics::Trend.types.count', -2) do
      delete :destroy, params: { :id => foreman_trend.id.to_param }
      delete :destroy, params: { :id => fact_trend.id.to_param }
    end
    assert_response :success
  end
end
