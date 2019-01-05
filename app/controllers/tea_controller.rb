class TeaController < ApplicationController
  def new
    @project = Project.find_by(id: params[:project_id])
    if(@project.nil?)
      flash[:error] = "This project has been deleted or not exist!"
      redirect_to '/'
    end
    @tea = TimeEntryActivity.new
  end
  def create
    @project = Project.find_by(id: params[:project_id])
    if(@project.nil?)
      flash[:error] = "This project has been deleted or not existed!"
      redirect_to '/'
    end
    @pa = permitted_params
    @pa[:project_id] = params[:project_id]
    @tea = TimeEntryActivity.new(permitted_params)
    if @tea.save
      flash[:success] = "Activity created successfully"
      redirect_to controller: 'projects', action: 'show', id: params[:project_id], status: 200
    else
      flash.now[:error] = tea.errors[:base]
      render 'new'
    end
  end

  def edit
    @tea = TimeEntryActivity.find_by(id: params[:id])
    if(@tea.nil?) {
      flash[:error] = "This activity has been deleted or not existed!"
      redirect_to '/'
    }
  end

  def update
    @tea = TimeEntryActivity.find_by(id: params[:id])
    @tea.active = params[:active]
    if @tea.save
      flash[:success] = "Activity updated successfully"
      redirect_to controller: 'projects', action: 'show', id: params[:project_id], status: 200
    else
      flash.now[:error] = @tea.errors[:base]
      render 'edit'
    end
  end

  private
    def permitted_params
      params.require(:TimeEntryActivity).permit(:name, :active, :project_id)
    end
=begin
    def editable_params
      params.require(:TimeEntryActivity).permit(:active)
    end
=end
end