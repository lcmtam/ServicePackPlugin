class ProjectsController < ApplicationController
  include ModuleAssignmentHelper
  layout 'project', only: [:show]
  def new
    @project = Project.new
  end
  def create
    @devi = permitted_params()
    @project = Project.new(@devi)
    #test only!
    @project.identifier = @devi[:name] + "-web" if Rails.env.development?
    if @project.save
      flash[:success] = "Project #{@project.name} successfully created"
      #byebug
      if params[:createSP]
        # redirect_to "ServicePack#new", status: 200
        @vis = ModuleAssignment.new
        @vis.project_id = @project.id
        flash[:notice] = "This project also use Service Pack"
        #byebug
        @v = @vis.save
        byebug
      end
      redirect_to "/", status: 303
    else
      flash.now[:error] = "Cannot create a project without a name"
      render action: "new"
    end
  end

  def index
    @projects = Project.all
  end

  def filterSP
    @projects = ProjectsHasActivatedSP
  end

  def show
    @project = Project.find_by(id: params[:id])
    #byebug
    if @project.nil?
      flash[:error] = "Project might be deleted or not created yet"
      redirect_to "/"
    else
      @r = SPenabled?(params[:id])
      #byebug
      @enums = TimeEntryActivity.where(project_id: params[:id]).order(:id)
    end
  end

  def update
    # check if SPenabled? == true and not checked
    # check if SPenabled? == false and checked
    # else redirect_to '/'
    @project = Project.find_by(id: params[:id])
    #byebug
    if @project.nil?
      flash[:error] = "Project might be deleted or not created yet"
      redirect_to "/"
    end
    @r = SPenabled?(params[:id])
    if @r ^ params[:SPenabled] # state change
      if params[:SPenabled]
        #byebug
        EnableSP(params[:id])
        flash[:notice] = "Project #{@project.identifier} has SP enabled"
      else
        #byebug
        DisableSP(params[:id])
        flash[:notice] = "SP is disabled for project #{@project.identifier}"
      end
    else
      flash[:info] = "Nothing changed"
    end
    redirect_to action: 'show', id: params[:id], status: 302
  end

  def destroy
    @project = Project.find_by(project_id: params[:project_id])
    if @project.nil?
      flash[:error] = "Project might be deleted or not created yet"
      redirect_to "/projects"
    end
    if @project.clean_up == "success"
      flash[:notice] = "Project #{params[:id]} has been vanished."
      redirect_to "/projects"
    else
      flash[:error] = @project.errors[:base]
    end
  end

  private
    def permitted_params()
      #byebug
      params.require(:project).permit(:name) if Rails.env.development?
    end
end