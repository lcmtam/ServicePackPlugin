module EnumsManager
	def OverriddenIDs()
		time_entry_activities.where.not(parent_id: nil).pluck(:parent_id)
	end

	def LegitActivities(included_inactive = true)
		# magic
		# https://api.rubyonrails.org/classes/ActiveRecord/Result.html
		@sql = <<-SQL
			SELECT *
			FROM enumerations
			WHERE (project_id = ?
			OR project_id IS NULL)
			AND type = 'TimeEntryActivity'
			AND id NOT IN (
				SELECT t2.id
				FROM enumerations t1
				INNER JOIN enumerations t2 ON t1.parent_id = t2.id
				WHERE t1.project_id = ?
			)
		SQL
		@sql << "AND activity = 't'" unless included_inactive
		#TimeEntryActivity.find_by_sql([@sql1 + @sql2, project_id, project_id])
		a = [@sql, self.id, self.id ]
		conn = ActiveRecord::Base.sanitize_sql_array(a)
		return ActiveRecord::Base.connection.exec_query(conn)
	end

  	# blame strong params
  	def create_time_entry_activity_if_needed(activity, clean_params)
	    if activity.parent_id.nil? && overridden_activity?(activity, clean_params)
	      	clean_params[:name] = activity.name # and then some
	      	clean_params[:parent_id] = activity.id
	      	abc = self.create.time_entry_activities(clean_params)
	    else
	    	abc = activity.update_attributes(clean_params)
	    end

	  	if abc
	      return "successful"
	    else
	      return "denied"
	    end
  	end

  	private
	  	def overridden_activity?(activity, hash)
	    	activity.id == hash[:id] && hash[:active] ^ activity.active
  		end
end