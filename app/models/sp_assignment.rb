class SpAssignment < ApplicationRecord
  self.table_name = "sp_assign"
  belongs_to :project
  belongs_to :service_pack

  validates :service_pack_id, presence: { message: 'No Service Pack is assorted' }, uniqueness: { scope: :project_id }
  validates :project_id, presence: { message: 'No Project is assorted' }
  validate :project_must_have_service_pack_enabled, on: :create

  #todo: if module is not assigned then throw
  private
    def project_must_have_service_pack_enabled
      if ModuleAssignment.SPdisabled?(project_id)
        errors[:base] << "Service Pack is not enabled for this project!"
      end
    end
end