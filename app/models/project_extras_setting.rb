class ProjectExtrasSetting < ActiveRecord::Base
  unloadable
  has_many :project_extras_status_messages
  accepts_nested_attributes_for :project_extras_status_messages
end
