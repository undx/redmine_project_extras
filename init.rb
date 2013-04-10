require 'redmine'
require 'extras_projects_helper_patch'
require 'issue_patch'
require 'journal_patch'

Redmine::Plugin.register :project_extras do
  name 'Project Extras plugin'
  author 'Emmanuel GALLOIS'
  description 'Redmine'
  version '0.0.1'
  url 'http://github.com/undx/redmine_project_extras'
  author_url 'http://github.com/undx'

  project_module :project_extras do
    permission :mange_extras, {:project_extras => [:show, :edit]}, :require => :member
  end
  Rails.configuration.to_prepare do
    require_dependency 'projects_helper'
    unless ProjectsHelper.included_modules.include? ExtrasProjectsHelperPatch
      ProjectsHelper.send(:include, ExtrasProjectsHelperPatch)
    end
    unless Issue.included_modules.include? IssuePatch
      Issue.send(:include, IssuePatch)
    end
    unless Journal.included_modules.include? JournalPatch
      Journal.send(:include, JournalPatch)
    end
  end
end

