module ForemanStatistics
  class Engine < ::Rails::Engine
    isolate_namespace ForemanStatistics
    engine_name 'foreman_statistics'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'foreman_statistics.load_app_instance_data' do |app|
      ForemanStatistics::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_statistics.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_statistics do
        requires_foreman '>= 3.7'
        register_gettext

        # Add Global JS file for extending foreman-core components and routes
        register_global_js_file 'fills'

        # Remove core permissions
        %i[view_statistics view_trends create_trends edit_trends destroy_trends update_trends].each do |perm_name|
          p = Foreman::AccessControl.permission(perm_name)
          Foreman::AccessControl.remove_permission(p)
        end

        # Add permissions
        security_block :foreman_statistics do
          permission :view_statistics, { :'foreman_statistics/react' => [:index],
                                         :'foreman_statistics/statistics' => %i[index show],
                                         :'foreman_statistics/api/v2/statistics' => [:index] }

          permission :view_trends,     { :'foreman_statistics/trends' => %i[index show welcome],
                                         :'foreman_statistics/api/v2/trends' => %i[index show] },
            :resource_type => 'ForemanStatistics::Trend'
          permission :create_trends,   { :'foreman_statistics/trends' => %i[new create],
                                         :'foreman_statistics/api/v2/trends' => %i[new create] },
            :resource_type => 'ForemanStatistics::Trend'
          permission :edit_trends,     { :'foreman_statistics/trends' => %i[edit update] },
            :resource_type => 'ForemanStatistics::Trend'
          permission :destroy_trends,  { :'foreman_statistics/trends' => [:destroy],
                                         :'foreman_statistics/api/v2/trends' => [:destroy] },
            :resource_type => 'ForemanStatistics::Trend'
          permission :update_trends,   { :'foreman_statistics/trends' => [:count] },
            :resource_type => 'ForemanStatistics::Trend'
        end

        # add_resource_permissions_to_default_roles(['ForemanStatistics::Trend'])

        add_menu_item :top_menu, :trends, {
          :caption => N_('Trends'),
          :engine => ForemanStatistics::Engine, :parent => :monitor_menu, :after => :audits,
          :url_hash => { :controller => 'foreman_statistics/trends', :action => :index }
        }

        add_menu_item :top_menu, :statistics, {
          :caption => N_('Statistics'),
          :engine => ForemanStatistics::Engine, :parent => :monitor_menu, :after => :trends,
          :url_hash => { :controller => 'foreman_statistics/statistics', :action => :index }
        }

        settings do
          category(:general) do
            setting('max_trend',
              type: :integer,
              default: 30,
              description: N_('Max days for Trends graphs'),
              full_name: N_('Max trends'),
              validate: { numericality: { greater_than: 0 } })
          end
        end
      end
    end

    initializer 'foreman_statistics.apipie' do
      p = Foreman::Plugin.find(:foreman_statistics)
      p.apipie_documented_controllers(["#{ForemanStatistics::Engine.root}/app/controllers/foreman_statistics/api/v2/*.rb"])
      Apipie.configuration.checksum_path += ['/foreman_statistics/api/']
    end

    initializer 'foreman_statistics.trend_counter_job' do
      ::Foreman::Application.dynflow.config.on_init do |world|
        TrendCounterJob.spawn_if_missing(world)
      end
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      ::ComputeResource.include ForemanStatistics::HasManyTrends
      ::Hostgroup.include ForemanStatistics::HasManyTrends
      ::Model.include ForemanStatistics::HasManyTrends
      ::Operatingsystem.include ForemanStatistics::HasManyTrends
      'ForemanPuppet::Environment'.safe_constantize&.include ForemanStatistics::HasManyTrends
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanStatistics::Engine.load_seed
      end
    end
  end
end
