module ModuleAssignmentHelper
  def enable_sp(project_id)
    @vis = ModuleAssignment.new
    @vis.project_id = @project.id
    @vis.save
  end
  def disable_sp(project_id)
    ModuleAssignment.find_by("project_id = ?", project_id).destroy
  end
  def sp_enabled?(project_id)
    !sp_disabled?(project_id)
  end
  def sp_disabled?(project_id)
    ModuleAssignment.SPenabled?(project_id).empty?
  end
  #def ProjectsHasActivatedSP
  def projects_has_activated_sp
    @sql = <<-SQL
    SELECT * FROM projects
    INNER JOIN module_assignments
    ON module_assignments.project_id == projects.id
    SQL
    #byebug
    Project.find_by_sql(@sql);
  end
end