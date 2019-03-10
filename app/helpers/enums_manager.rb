module EnumsManager
	def overridden_ids()
		time_entry_activities.where.not(parent_id: nil).pluck(:parent_id)
	end

	def leg_acts(included_inactive = true)
		# https://api.rubyonrails.org/classes/ActiveRecord/Result.html
    # get every fields as this will be used in many contexts.
    # No NULL in a IN clause - NULL is supposed to act weird.

		@sql = <<-SQL
			SELECT *
			FROM enumerations
			WHERE (project_id = ?
			OR project_id IS NULL)
			AND type = 'TimeEntryActivity'
			AND id NOT IN (
				SELECT parent_id
				FROM enumerations
				WHERE parent_id IS NOT NULL
        AND project_id = ?
        AND type = 'TimeEntryActivity'
			)
		SQL
		@sql << "AND activity = 't'" unless included_inactive
    # this #[class.name}.find_by_sql packs the results in Rails renderable forms.
		TimeEntryActivity.find_by_sql([@sql, id, id])
		#a = [@sql, self.id, self.id ]
		#conn = ActiveRecord::Base.send(:sanitize_sql_array, a)
		#return ActiveRecord::Base.connection.exec_query(conn)
	end

  	# blame strong params
  	def create_time_entry_activity_if_needed(activity, clean_params)
      # return "successful" if records are changed/saved
        msg = wrapped_magic_do_not_touch(activity, clean_params)
        if !msg.is_a?(Symbol)
            time_entries.where(activity_id: activity.id)
            .update_all(activity_id: msg)
            msg = :successful
        end
        return msg
  	end

  	private
      def wrapped_magic_do_not_touch(activity, clean_params)
        if malicious_override?(activity, clean_params)
          logger.debug { "Malicious override " << clean_params.to_s}
          return :denied
        end
   
        if activity.parent_id
          activity.update!(clean_params)
           logger.debug {"Mere update " << clean_params.to_s}
          return :successful
        else
          logger.debug {"More creation " << clean_params.to_s }
          if overridden_activity?(activity, clean_params)
            acti = self.time_entry_activities.new(clean_params)
            acti.name = activity.name
            acti.save!
            if acti.persisted?
              logger.debug {"Nice"}
              return acti.id
            else
              logger.debug {"meh"}
              return :denied
            end
          else
            return :successful
          end
        end
      end
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