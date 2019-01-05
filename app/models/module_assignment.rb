# 1 hack(s) found.

require_dependency "project.rb" # hack: autoloading broke.

class ModuleAssignment < ActiveRecord::Base
  has_one :Project, inverse_of: :module_assignment # hacky
  validates :project_id, uniqueness: true # now it does work
  scope :SPenabled?, ->(id) { where(project_id: id) }
  # no :SPdisabled? though.
end