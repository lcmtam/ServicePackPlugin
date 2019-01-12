module EnumsManager
	def overridden_ids()
		time_entry_activities.where.not(parent_id: nil).pluck(:parent_id)
	end

	def legit_activities(included_inactive = true)
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
		TimeEntryActivity.find_by_sql([@sql, id, id])
		#a = [@sql, self.id, self.id ]
		#conn = ActiveRecord::Base.send(:sanitize_sql_array, a)
		#return ActiveRecord::Base.connection.exec_query(conn)
	end

  	# blame strong params
  	def create_time_entry_activity_if_needed(activity, clean_params)
  		#if activity is shared
  		#if overridden
  		#and not malicious
  		if malicious_override?(activity, clean_params)
  			logger.debug { "Malicious override " << clean_params.to_s}
  			return "denied"
  		end
 
  		if activity.parent_id
  			activity.update!(clean_params)
  			 logger.debug {"Mere update " << clean_params.to_s}
  			return "successful"
  		else
  			logger.debug {"More creation " << clean_params.to_s }
  			if overridden_activity?(activity, clean_params)
  				acti = self.time_entry_activities.new(clean_params)
  				acti.name = activity.name
  				acti.save!
  				if acti.persisted?
  					logger.debug {"Nice su\n"}
  					return "denied"
  				else
  					logger.debug {"meh"}
  					return "successful"
  				end
  			else
  				return "successful"
  			end
  		end
  	end

  	private
	  	def overridden_activity?(activity, hash)
	  		logger.debug { "Hash pid " << (hash.has_key?(:parent_id) ? hash[:parent_id].to_s : "NULL") << " and " << hash[:active].to_s}
	    	activity.id == hash[:parent_id].to_i && hash[:active] != activity.active.to_s
  		end
  		def malicious_override?(activity, hash)
  			# anything can bind to .shared
  			# but no rebind or unbind shall pass!
  			activity.parent_id && (hash[:parent_id] && activity.id != hash[:parent_id].to_i)
  			# hash[:parent_id] SHALL BE omitted for overridden one.
  		end
end