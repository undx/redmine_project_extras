class CreateProjectExtrasSettings < ActiveRecord::Migration
  def change
    create_table :project_extras_settings do |t|
      t.integer :project_id, :null => false
      t.integer :default_assigned_to_id
      t.text :default_issue_status_message
      t.boolean :include_default_issue_status_message, :default => false
    end
  end
end
