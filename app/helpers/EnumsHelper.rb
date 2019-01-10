module EnumsHelper
	def OverriddenIDs(project_id)
		TimeEntryActivity.(project:project_id).where.not(parent_id: nil).pluck(:parent_id)
	end
	def LegitActivities(project_id, active = true)
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
		@sql << "AND activity = 't'" if active
		#TimeEntryActivity.find_by_sql([@sql1 + @sql2, project_id, project_id])
		a = [@sql, project_id, project_id ]
		conn = ActiveRecord::Base.sanitize_sql_array(a)
		ActiveRecord::Base.connection.exec_query(conn)
	end
end