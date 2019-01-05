class SPAssign < ApplicationRecord
  belongs_to :project
  belongs_to :ServicePack

  validate :ServicePack_id, presence: { message: "No Service Pack is assorted" }, uniqueness: { scope :Project_id }
  validate :Project_id, presence: { message: "No Project is assorted" }
  validate :validate_assigned(project_id)

  #todo: if module is not assigned then throw
  private
    def validate_assigned(project_id)
      if ModuleAssignment.SPenabled?(project_id)
        errors[:base] = "Service Pack is not enabled for this project!"
      end
    end
end