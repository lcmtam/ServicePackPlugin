class AdminController < ApplicationController
	def opis
		@h = Hash.new
		@h[:te] = "<a href='/admin/index'>Systemwide #TEA</a>"
	end
	def index
		# showing shared enums here
		@enums = TimeEntryActivity.shared
	end
	def new
		@tea = TimeEntryActivity.new
	end
	def create
		@pa = permitted_params
		#@pa[:project_id] = nil
		#byebug
		@tea = TimeEntryActivity.new(@pa)
		if @tea.save!
			flash[:success] = "Activity created successfully"
			redirect_to action:'index'
		else
			flash.now[:error] = @tea.errors[:base]
			render 'new'
		end
	end
	#taken by TEA controller :p
	def edit
    # find(params[:id]) also works as shorthand for primary key field
    # but it throws exception!
	    @tea = TimeEntryActivity.find_by(id: params[:id]) 
	    if @tea.nil?
	      flash[:error] = "This activity has been deleted or not existed!"
	      redirect_to '/'
    end
    def 
  end
	private
		def permitted_params
			params.require(:time_entry_activity).permit(:name, :active)
		end
end