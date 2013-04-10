require_dependency 'projects_helper'

module ExtrasProjectsHelperPatch
  def self.included base
    base.send :include, ProjectsHelperMethodsBanner
    base.class_eval do
      unloadable
      alias_method_chain :project_settings_tabs, :extras
    end
  end
end

module ProjectsHelperMethodsBanner
  def project_settings_tabs_with_extras
    tabs = project_settings_tabs_without_extras
    puts "###################################"
    puts tabs
    action = {
      :name => 'project_extras',
      :controller => 'project_extras',
      :action => :show,
      :partial => 'project_extras/show',
      :label => :project_extras
    }
    puts action
    tabs << action if User.current.allowed_to?(action, @project)
    tabs
  end
end

ProjectsHelper.send(:include, ExtrasProjectsHelperPatch)
