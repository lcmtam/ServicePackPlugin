class TimeEntryActivitiesController < ApplicationController
  def new
    # two controllers
    @project = Project.find_by(id: params[:project_id])
    if @project.nil?
      flash[:error] = "This project has been deleted or not existed!"
      redirect_to '/'
    end

    @tea = @project.time_entry_activity.new
  end

  def create
    # look again!
    @project = Project.find_by(id: params[:project_id])
    if @project.nil?
      flash[:error] = "This project has been deleted or not existed!"
      redirect_to '/'
    end
    @pa = permitted_params
    @pa[:project_id] = params[:project_id]
    #byebug
    @tea = TimeEntryActivity.new(@pa)
    if @tea.save
      flash[:success] = "Activity created successfully"
        if !@tea.shared?
          redirect_to controller: 'projects', action: 'show', id: params[:project_id], status: 307
        else
          redirect_to '/'
        end
    else
      flash.now[:error] = @tea.errors[:base]
      render 'new', id: params[:project_id]
    end
  end

  def edit
    # find(params[:id]) also works as shorthand for primary key field
    # but it throws exception!
    @tea = TimeEntryActivity.find_by(id: params[:id])
    #byebug
    if @tea.nil?
      flash[:error] = "This activity has been deleted or not existed!"
      redirect_to '/'
    end
  end

  def update
    @tea = TimeEntryActivity.find_by(id: params[:id])
    @pa = permitted_params
    is_shared = @tea.shared?
    @pa[:project_id] = params[:project_id]
    # @tea.active = params[:active]
    if @tea.nil?
      flash[:error] = "This activity has been deleted or not existed!"
      redirect_to '/'
    end
    byebug
    @tea.update(@pa)
    if @tea.save
      flash[:success] = "Activity updated successfully"
      byebug
        if !is_shared
          redirect_to controller: 'projects', action: 'show', id: params[:project_id], status: 307
        else
          redirect_to '/admin/index'
        end
    else
      flash.now[:error] = @tea.errors[:base]
      render 'edit', id: params[:id]
    end
  end 

  private
    def permitted_params
      params.require(:time_entry_activity).permit(:name, :active, :project_id)
    end

    def editable_params
      params.require(:time_entry_activity).permit(:active, :name)
    end

end