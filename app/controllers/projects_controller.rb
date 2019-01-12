#require File.new('/develop/doit/app/helpers/module_assignment_helper.rb')

class ProjectsController < ApplicationController
  #autoload :ModuleAssignmentHelper, '/helpers/module_assignment_helper.rb'
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
=begin
        @vis = ModuleAssignment.new
        @vis.project_id = @project.id

        #byebug
        @v = @vis.save
=end
        enable_sp(@project.id)
        flash[:notice] = "This project also use Service Pack"
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
    #@projects = ProjectsHasActivatedSP
    @projects = projects_has_activated_sp
  end

  def show
    @project = Project.find_by(id: params[:id])
    #byebug
    if @project.nil?
      flash[:error] = "Project might be deleted or not created yet"
      redirect_to "/"
    else
      @r = sp_enabled?(params[:id])
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
    @r = sp_enabled?(params[:id])
    if @r ^ params[:SPenabled] # state change
      if params[:SPenabled]
        #byebug
        enable_sp(params[:id])
        flash[:notice] = "Project #{@project.identifier} has SP enabled"
      else
        #byebug
        disable_sp(params[:id])
        flash[:notice] = "SP is disabled for project #{@project.identifier}"
      end
    else
      flash[:info] = "Nothing changed"
    end
    redirect_to action: 'show', id: params[:id], status: 302
  end

  def edit_activities
    @project = Project.find_by(id: params[:project_id])
    if @project.nil?
      flash[:error] = "Project might be deleted or not created yet"
      redirect_to "/" and return
    end
    @enums = @project.legit_activities
    #byebug
  end
  def update_activities
    @project = Project.find_by(id: params[:project_id])
    if @project.nil?
      flash[:error] = "Project might be deleted or not created yet"
      redirect_to "/" and return
    end
    @pa = kept_params
    count = 0
    #byebug
    @pa.each do |activity_id, hash|
      #byebug
      t = @project.create_time_entry_activity_if_needed(TimeEntryActivity.find(activity_id), hash)
      count += 1 if t == "successful"
    end
    flash[:success] = "#{count} activities updated successfully"
    redirect_to @project
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
    def kept_params()
      params.require(:activities).permit!
    end
end