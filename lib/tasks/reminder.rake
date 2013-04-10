#!/usr/bin/env ruby
#
namespace :redmine do
  namespace :plugins do
    namespace :project_extras do
      desc <<-END_DESC
Send a reminder email for forgotten issues.

General options:
  days=NUMBER_OF_DAYS      [Mandatory] specify the number of days to fetch
                           issues older than today - NUMBER_OF_DAYS.
  message="BETWEEN QUOTES" [Mandatory] the message to send in the notify email.

Issue attributes control options:
  project=PROJECT          [Mandatory] identifier of the target project.
  tracker=TRACKER          name of the target tracker.
  user=login               User's login used for notification. If not specified,
                           fetch the first administrator available.
END_DESC
      task :reminder => :environment do |t, args|
        parm_project = ENV["project"]
        parm_tracker = ENV["tracker"]
        parm_message = ENV["message"]
        parm_days    = ENV["days"]
        parm_user    = ENV["user"]
        if parm_project.nil? || parm_message.nil? || parm_days.nil?
          puts "Missing parameter(s) ! Aborting..."
          exit
        end
        unless parm_tracker.nil?
          begin
            tracker = Tracker.find_by_name(parm_tracker)
          rescue
            puts "Invalid tracker specified: \"#{parm_tracker}\". Available: #{Tracker.all.collect &:name}"
            exit
          end
        end
        if parm_user
          user = User.find_by_login parm_user
        end
        if user.nil?
          user = User.where(:admin => true).first
        end
        begin
          project = Project.find(parm_project)
        rescue
          puts "Invalid project #{parm_project} ! Aborting..."
          exit
        end
        time = DateTime.now - parm_days.to_i.days
        puts "Looking for non closed issues. Project: #{project} / Tracker: #{tracker} and older than #{time}. [#{user}]"
        issues = Issue.where(:project_id=> project.id).where('updated_on <=?', [time])
        issues.where(:tracker_id => tracker.id) if tracker
        issues.each do |issue|
          unless issue.closed?
            issue.init_journal(user, parm_message)
            issue.save
          end
        end
      end
    end
  end
end
