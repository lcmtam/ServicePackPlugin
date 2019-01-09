class ServicePacksController < ApplicationController
	# include ModuleAssignmentHelper
=begin
	def new
		@project = Project.find_by(id: params[:project_id])
		if(!@project)
			flash[:error] = "Project not found"
			redirect_to "/project" and return
		end
		if SPdisabled?(@project.id)
			flash[:error] = "Project does not have SP module enabled"
			redirect_to "/project", id: params[:project_id]
		end
		@sp = ServicePack.new
	end
=end
	def new
		@sp = ServicePack.new
	end
	def create
		@pa = permitted_params
		# @pa[:project_id] = params[:project_id] # FOR TESTING ONLY!
		@sp = ServicePack.new(@pa)
		byebug
		if !@sp.save!
			flash.now[:error] = @sp.errors[:base]
			render action: 'new'
		else
			flash[:success] = "Service Pack creation successful"
			redirect_to service_pack_path(@sp.id)
		end
		
	end
	def show
		@spp = ServicePack.find_by(id: params[:id])
		if(!@spp)
			flash[:error] = "Service Pack not found or not created yet"
			redirect_to "/projects"
		end
	end

	private
		def permitted_params
			params.require(:service_pack).permit(:name, :activation_date, :expiration_date, :threshold2, :threshold1, :capacity)
		end
end