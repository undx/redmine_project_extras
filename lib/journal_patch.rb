module JournalPatch
  require_dependency 'journal'
  Journal.class_eval do
    before_save :project_extras_before_save

    def project_extras_before_save
      logger.debug {"[Project extras] JOURNAL for # #{journalized_id}; #{journalized_type}; journal : #{self} jnotes: #{self.notes}"}
    end
  end
end

