class SpAssignmentsController < ApplicationController
	include ModuleAssignmentHelper
	def new
		@project = Project.find_by(id: params[:project_id])
		if !@project
			flash[:error] = "Project not found!"
			redirect_to "/projects" and return
		end
		if sp_disabled?(@project.id)
			flash[:error] = "Please activate Service Pack module for this project!"
			redirect_to "/projects/", id: @project.id and return
		end
		@sp = ServicePack.where("expiration_date >= ?", Date.today)
		#byebug
		@spa = SpAssignment.new
	end

	def create
		@project = Project.find_by(id: params[:project_id])
		if !@project
			flash[:error] = "Project not found!"
			redirect_to "/projects" and return
		end
		if sp_disabled?(@project.id)
			flash[:error] = "Please activate Service Pack module for this project!"
			redirect_to "/projects/", id: @project.id and return
		end
		# todo: all mapping MUST be present for successful assignment.
		# no need to, it's secured by the model.
	end

	private
		def permitted_params
			params.permit(:project_id, :service_pack_id)
		end
end