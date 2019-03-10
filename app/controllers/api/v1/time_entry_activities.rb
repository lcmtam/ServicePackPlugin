module API
	module V1
		class TimeEntryActivities < Grape::API
			include API::V1::Defaults

			resource :time_entry_activities do
				desc 'Return all activities, test'
				get '', root: :time_entry_activities do
					TimeEntryActivity.all
				end
				desc 'Return all activities from a project'
				params do
					requires :project_id, type: String, desc: 'Project ID'
				end
				get ':project_id', root: :time_entry_activities do
					Project.find(permitted_params[:project_id]).leg_acts
				end
			end
		end
	end
end