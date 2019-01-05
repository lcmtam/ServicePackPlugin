module ModuleAssignmentHelper
  def enableSP(project_id)
    @vis = ModuleAssignment.new
    @vis.project_id = @project.id
    @vis.save
  end
  def disableSP(project_id)
    ModuleAssignment.find_by("project_id = ?", project_id).destroy
  end
  def SPenabled?(project_id)
    !SPdisabled?(project_id)
  end
  def SPdisabled?(project_id)
    ModuleAssignment.SPenabled?(project_id).empty?
  end
end