module RedmineLandingPage
  module Patches
    module WelcomeControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          alias_method :index_without_landing_page, :index unless method_defined? :index_without_landing_page

          def index            
            landing_page = Setting["plugin_redmine_landing_page"]["default_landing_page"]            
            if User.current.logged? &&
               User.current.landing_page &&
               !User.current.landing_page.empty?
              landing_page = User.current.landing_page
            end
            
            if landing_page && !landing_page.empty? && params[:main] == nil
              current_uri = URI(landing_page)
              if current_uri.relative?                
                landing_page = URI(request.url + "/").merge(landing_page).to_s
              end
              redirect_to landing_page, :status => 302
            else
              params.delete(:main)
              index_without_landing_page              
            end
          end
        end
      end
    end
  end
end
