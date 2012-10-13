require 'uri'

module RedmineLandingPage
  module Patches
    module ProjectsControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          alias_method :show_without_landing_page, :show unless method_defined? :show_without_landing_page

          def show
            landing_page = Setting["plugin_redmine_landing_page"]["default_project_landing_page"]            
            if @project.landing_page && !@project.landing_page.empty?
              landing_page = @project.landing_page
            end
            
            if landing_page && !landing_page.empty? && params[:overview] == nil && params[:jump] == nil
              current_uri = URI(landing_page)
              if current_uri.relative?                
                landing_page = URI(request.url + "/").merge(landing_page).to_s
              end
              redirect_to landing_page, :status => 302
            else
              params.delete(:overview)
              show_without_landing_page              
            end
          end
        end
      end
    end
  end
end
