module IssuePatch
  require_dependency 'issue'
  Issue.class_eval do
    before_save :project_extras_before_save

    def project_extras_before_save
      logger.debug{"[Project extras] assigned_to: #{assigned_to}; project_id: #{project_id}"}
      settings = ProjectExtrasSetting.find_by_project_id project_id
      logger.debug {"[Project extras] settings for project: #{settings}"}
      # Assign default assignee
      if assigned_to_id.nil?
        if settings
          self.assigned_to_id = settings.default_assigned_to_id
          log.debug{"[Project extras] Assigned to default assignee."}
        end
      end
      # Update journal with default message if necessary
      if status_id == status_id_was and not settings.send_when_update
        return
      end
      message = settings.default_issue_status_message if settings.include_default_issue_status_message
      issue_message = ""
      settings.project_extras_status_messages.map {|m| issue_message = m.message if m.status_id==status_id}
      issue_message = message if issue_message.empty?
      if self.current_journal
        notes = self.current_journal.notes
        notes ||= ""
        begin
          self.current_journal.notes = issue_message+"\n\n" + notes
        rescue
          #self.init_journal(User.current, issue_message)
        end
      else
        self.init_journal(User.current, issue_message)
      end
    end
  end
end

