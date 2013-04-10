class ProjectExtrasController < ApplicationController
  unloadable
  def index
    puts params
  end
  def show
    @project = Project.find(params[:project_id])
    puts @project
    puts params[:project_id]
  end

  def edit
    puts params
    @project = Project.find(params[:project_id])
    @messages = params[:settings][:project_extras_status_messages]
    puts "messages: #{@messages}"
    params[:settings].delete(:project_extras_status_messages)
    @extra = ProjectExtrasSetting.find(params[:setting_id])
    @extra.update_attributes params[:settings]
    if @messages
      @messages.each do |k,v|
        unless v.empty?
          sm = ProjectExtrasStatusMessage.find(k)
          sm.message = v
          sm.save
        else
          ProjectExtrasStatusMessage.delete(k)
        end
      end
    end
    unless params[:new_status_message].empty?
      pesm = ProjectExtrasStatusMessage.new
      pesm.status_id = params[:new_status_message]
      pesm.project_extras_setting_id = @extra.id
      @extra.project_extras_status_messages << pesm
      @extra.save
    end
    #flash[:notice] = l(:notice_successful_update)
    redirect_to :controller => 'projects', :action => "settings", :id => @project, :tab => 'project_extras'
  end

  def add_status_message
    puts params
    redirect_to :controller => 'projects', :action => "settings", :id => @project, :tab => 'project_extras'
  end

  def preview
    puts params
    @text = params[:settings][:default_issue_status_message]
    render :partial => 'common/preview'
  end
  
end
