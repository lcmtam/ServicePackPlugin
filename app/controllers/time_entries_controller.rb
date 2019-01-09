class TimeEntriesController < ApplicationController
  layout 'time_entry', except: [:show, :create, :edit]
  def new
    @project = Project.find_by(id: params[:project_id])
    ##byebug
    if @project.nil?
      ##byebug
      flash[:error] = "Project might be deleted or not created yet"
      redirect_to "/"
    else
      @time_entry = TimeEntry.new(project_id: @project.id)
      @enums = TimeEntryActivity.project(params[:project_id]).active
      #byebug
      ##byebug
      if @enums.empty?
        flash[:error] = "No activity is set!"
        redirect_to new_project_time_entry_activity_path(@project.id)
      end
    end
  end

  def create
    @pa = permitted_params
    @project = Project.find_by(id: params[:project_id])
    #byebug
    if @project.nil?
      #byebug
      flash[:error] = "Project might be deleted or not created yet"
      redirect_to "/"
    else
      ##byebug
      #@pa[:activity_id] = params[:time_entry][:activity_id]
      #@pa[:hours] = params[:time_entry][:hours]
      #@pa[:spent_on] = Date.parse(params[:time_entry][:spent_on])
      @pa[:project_id] = params[:project_id]
      ##byebug
      # @te = Project.time_entries.create(@pa)
     @te = TimeEntry.new(@pa)
      #byebug
      if !@te.save!
        flash.now[:error] = @te.errors.full_messages
        redirect_to action: 'new'
      else
        flash[:success] = "Logged complete"
        redirect_to action: 'show', id: @te.id, status: 200
      end
    end
  end

  def show
    @te = TimeEntry.find_by(id: params[:id])
    if @te.nil?
      flash.now[:error] = "Time entry not found"
      redirect_to "/" and return
    else
      @w = TimeEntryActivity.select(:name).find_by(id: @te.activity_id)
    end
    #byebug
  end

  def index
    @project = Project.find_by(id: params[:project_id])
    ##byebug
    if @project.nil?
      ##byebug
      flash[:error] = "Project might be deleted or not created yet"
      redirect_to "/"
    else
      @te = TimeEntry.includes(:TimeEntryActivity) # like join but lazy-load the joined one
      @te = @te.where(project_id: params[:project_id]).order(:spent_on)
    end
  end

  def edit
    @te = TimeEntry.find_by(id: params[:id])
    #byebug
    if @te.nil?
      flash.now[:error] = "Time entry not found"
      redirect_to "/" and return
    end
    @enums = TimeEntryActivity.project(@te.project_id).active
  end

  def update
    @pa = editable_params
    @te= TimeEntry.find_by(id: params[:id])
    #byebug
    if @te.nil?
      #byebug
      flash[:error] = "Time Entry not found"
      redirect_to "/"
    else
      ##byebug
      #@pa[:activity_id] = params[:time_entry][:activity_id]
      #@pa[:hours] = params[:time_entry][:hours]
      #@pa[:spent_on] = Date.parse(params[:time_entry][:spent_on])
      ##byebug
      # @te = Project.time_entries.create(@pa)
     @te.update(@pa)
      #byebug
      if !@te.save
        flash.now[:error] = @te.errors.full_messages
        render action: 'edit', id: params[:project_id]
      else
        flash[:success] = "Log edit successfully"
        redirect_to action: 'show', id: @te[:id], status: 200
      end
    end
  end


  private
    def permitted_params
      params.require(:time_entry).permit(:hours, :spent_on, :activity_id, :project_id, :comment)
    end
    def editable_params
      params.require(:time_entry).permit(:hours, :spent_on, :activity_id, :comment)
    end
end