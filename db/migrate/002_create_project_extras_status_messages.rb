class CreateProjectExtrasStatusMessages < ActiveRecord::Migration
  def change
    create_table :project_extras_status_messages do |t|
      t.integer :project_extras_setting_id, :null => false
      t.integer :status_id, :null => false
      t.text :message, :default => 'Enter default status message'
    end
  end
end
