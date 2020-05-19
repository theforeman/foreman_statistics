require_relative '../../test_plugin_helper'

module ForemanStatistics
  class TrendsControllerTest < ActionController::TestCase
    setup do
      @routes = ForemanStatistics::Engine.routes
      Setting::General.create(:name => 'max_trend', :default => 30, :description => 'Max days for Trends graphs')
    end

    let(:os_trend) { FactoryBot.create(:foreman_statistics_trend_os) }
    let(:os_trend_with_counters) do
      FactoryBot.create(:foreman_statistics_trend_os, :with_values, :with_counters)
    end

    describe 'GET #index' do
      setup do
        @old = Setting[:entries_per_page]
        Setting[:entries_per_page] = entries_per_page
      end
      teardown do
        Setting[:entries_per_page] = @old
      end

      describe 'pagination rendered' do
        setup { os_trend }
        let(:entries_per_page) { 1 }

        test 'should not render pagination' do
          get :index, session: set_session_user
          assert_response :success
          assert_not_includes @response.body, 'id=pagination'
        end

        test 'should render pagination' do
          get :index, session: set_session_user
          assert_response :success
          assert_select "div[id='pagination']"
        end
      end

      describe 'pagination per page' do
        setup { trends }
        let(:entries_per_page) { 5 }
        let(:trends) { FactoryBot.create_list(:foreman_statistics_trend_os, entries_per_page + 2) }

        test 'should render correct per_page value' do
          get :index, params: { per_page: entries_per_page + 1 }, session: set_session_user
          assert_response :success
          per_page_results = response.body.scan(/perPage":\d+/).first.gsub(/[^\d]/, '').to_i
          assert_equal entries_per_page, per_page_results
        end

        test 'should render per page dropdown with correct values' do
          get :index, params: { per_page: entries_per_page + 1 }, session: set_session_user
          assert_response :success
          assert_not_nil response.body['perPageOptions":[5,6,10,15,25,50]']
        end

        test 'sort links should include per page param' do
          get :index, params: { per_page: entries_per_page + 1 }, session: set_session_user
          assert_response :success
          sort_links = css_select('thead a')
          sort_links.each do |link|
            assert_includes link['href'], "per_page=#{entries_per_page + 1}"
          end
        end
      end
    end

    test 'should get empty_data page, if no trend counters exist' do
      get :show, params: { :id => os_trend.id }, session: set_session_user
      assert_response :success
      assert_template :partial => 'foreman_statistics/trends/_empty_data'
    end

    test 'should show Foreman model trend' do
      get :show, params: { :id => os_trend_with_counters.id }, session: set_session_user
      assert_response :success
      assert_template 'show'
    end

    test 'should show Foreman model trend value details' do
      trend_value = os_trend_with_counters.values.find { |t| t.trend_counters.any? }
      get :show, params: { :id => trend_value.id }, session: set_session_user
      assert_response :success
      assert_template 'show'
    end

    test 'should show fact trend' do
      get :show, params: { :id => os_trend_with_counters.id }, session: set_session_user
      assert_response :success
      assert_template 'show'
    end

    test 'should show fact trend value details' do
      trend_value = os_trend_with_counters.values.find { |t| t.trend_counters.any? }
      get :show, params: { :id => trend_value.id }, session: set_session_user
      assert_response :success
      assert_template 'show'
    end

    test 'should create trend' do
      trend_parameters = { :name => 'test', :fact_name => 'os',
                           :fact_value => 'fedora', :trendable_type => 'FactName' }
      post :create, params: { :trend => trend_parameters }, session: set_session_user
      assert_response :success
    end

    test 'should update trend' do
      put :edit, params: { :id => os_trend.id, :trend => { :name => 'test2' } },
                 session: set_session_user
      assert_response :success
    end
  end
end
