class AddSendWhenUpdateToProjectExtrasSettings < ActiveRecord::Migration
  def change
    add_column :project_extras_settings, :send_when_update, :boolean, :default => false
  end
end
