class ProjectExtrasStatusMessage < ActiveRecord::Base
  unloadable
  belongs_to :project_extras_settings
end
