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
      next unless Gem::Dependency.new('', '>= 2.2').match?('', SETTINGS[:version])
      ForemanStatistics::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_statistics.cleanup_core' do
      next if Gem::Dependency.new('', '>= 2.2').match?('', SETTINGS[:version])
      Permission.where(:resource_type => 'Trend').update_all(:resource_type => 'ForemanStatistics::Trend')
    end

    initializer 'foreman_statistics.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_statistics do
        requires_foreman '>= 2.1.0'

        # ==== Core cleanups
        # TODO: clean up when this gets removed from core
        delete_menu_item :top_menu, :trends
        delete_menu_item :top_menu, :statistics
        # ====

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
      end
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      ::ComputeResource.include ForemanStatistics::ComputeResourceDecorations
      ::Environment.include ForemanStatistics::EnvironmentDecorations
      ::Hostgroup.include ForemanStatistics::HostgroupDecorations
      ::Model.include ForemanStatistics::ModelDecorations
      ::Operatingsystem.include ForemanStatistics::OperatingsystemDecorations
      ::Setting.include ForemanStatistics::SettingDecorations
      ::Setting::General.prepend ForemanStatistics::GeneralSettingDecorations
      begin
        ::Setting::General.load_defaults
      rescue ActiveRecord::NoDatabaseError => e
        Rails.logger.warn e
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanStatistics::Engine.load_seed
      end
    end

    initializer 'foreman_statistics.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../..', __dir__), 'locale')
      locale_domain = 'foreman_statistics'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
