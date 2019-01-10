module ModuleAssignmentHelper
  def EnableSP(project_id)
    @vis = ModuleAssignment.new
    @vis.project_id = @project.id
    @vis.save
  end
  def DisableSP(project_id)
    ModuleAssignment.find_by("project_id = ?", project_id).destroy
  end
  def SPenabled?(project_id)
    !SPdisabled?(project_id)
  end
  def SPdisabled?(project_id)
    ModuleAssignment.SPenabled?(project_id).empty?
  end
  def ProjectsHasActivatedSP
    @sql = <<-SQL
    SELECT * FROM projects
    INNER JOIN module_assignments
    ON module_assignments.project_id == projects.id
    SQL
    #byebug
    Project.find_by_sql(@sql);
  end
end