require 'redmine'

Redmine::Plugin.register :redmine_landing_page do
  name 'Redmine Landing Page plugin'
  author 'Igor Zubkov'
  description 'Redmine Landing Page plugin'
  version '0.0.2'
  url 'https://github.com/biow0lf/redmine_landing_page'
  author_url 'https://github.com/biow0lf'

  delete_menu_item :top_menu, :home
  menu :top_menu, :home, { :controller => 'welcome', :action => 'index', :main => 'welcome' }, :caption => :label_home, :before => :my_page

  delete_menu_item :project_menu, :overview
  menu :project_menu, :overview, { :controller => 'projects', :action => 'show', :overview => 'overview' }, :caption => :label_overview, :before => :activity, :param => :id

  settings :default => {"default_landing_page" => "",
                        "default_project_landing_page" => ""},
           :partial => "landing_page/landing_page_settings"
end

require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

if Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare do
    require_dependency 'projects_controller'
    ProjectsController.send(:include, RedmineLandingPage::Patches::ProjectsControllerPatch)

    require_dependency 'project'
    Project.send(:include, RedmineLandingPage::Patches::ProjectPatch)

    require_dependency 'principal'
    User.send(:include, RedmineLandingPage::Patches::UserPatch)

    require_dependency 'welcome_controller'
    WelcomeController.send(:include, RedmineLandingPage::Patches::WelcomeControllerPatch)
  end
else
  Dispatcher.to_prepare :redmine_contracts do
    require_dependency 'projects_controller'
    ProjectsController.send(:include, RedmineLandingPage::Patches::ProjectsControllerPatch)

    require_dependency 'project'
    Project.send(:include, RedmineLandingPage::Patches::ProjectPatch)

    require_dependency 'principal'
    User.send(:include, RedmineLandingPage::Patches::UserPatch)

    require_dependency 'welcome_controller'
    WelcomeController.send(:include, RedmineLandingPage::Patches::WelcomeControllerPatch)
  end
end

require 'redmine_landing_page/hooks/view_projects_form_hook'
require 'redmine_landing_page/hooks/view_my_account_hook'
require 'redmine_landing_page/hooks/view_users_form_hook'
