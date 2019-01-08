class TimeEntryActivitiesController < ApplicationController
  def new
    @project = Project.find_by(id: params[:project_id])
    if @project.nil?
      flash[:error] = "This project has been deleted or not existed!"
      redirect_to '/'
    end
    @tea = TimeEntryActivity.new
  end
  def create
    #error: Validation failed PROJECT must exist
    @project = Project.find_by(id: params[:project_id])
    if @project.nil?
      flash[:error] = "This project has been deleted or not existed!"
      redirect_to '/'
    end
    @pa = permitted_params
    @pa[:project_id] = params[:project_id]
    #byebug
    @tea = TimeEntryActivity.new(@pa)
    if @tea.save!
      flash[:success] = "Activity created successfully"
      redirect_to controller: 'projects', action: 'show', id: params[:project_id], status: 200
    else
      flash.now[:error] = @tea.errors[:base]
      render 'new', id: params[:project_id]
    end
  end

  def edit
    #find(params[:id]) also works as shorthand for primary key field
    @tea = TimeEntryActivity.find_by(id: params[:id]) 
    if @tea.nil?
      flash[:error] = "This activity has been deleted or not existed!"
      redirect_to '/'
    end
  end

  def update
    @tea = TimeEntryActivity.find_by(id: params[:id])
    @pa = permitted_params
    @pa[:project_id] = params[:project_id]
    @tea.active = params[:active]
    if @tea.nil?
      flash[:error] = "This activity has been deleted or not existed!"
      redirect_to '/'
    end
    if @tea.save
      flash[:success] = "Activity updated successfully"
      redirect_to controller: 'projects', action: 'show', id: params[:project_id], status: 200
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