class Project < ActiveRecord::Base
  has_many :time_entries, inverse_of: :project
  has_many :time_entry_activities, inverse_of: :project
  validates :name, presence: true
  validates :identifier, presence: true, uniqueness: {case_sensitive: false}
  def to_s
    self.name + ' - ' + self.identifier
  end
  def clean_up
    ActiveRecord::Base.transaction do
      TimeEntry.delete_all(project_id: params[:id])
      Enumeration.delete_all(project_id: params[:id])
      ModuleAssignment.delete_all(project_id: params[:id])
      destroy!
    rescue ActiveRecord::RecordInvalid
      errors[:base] << "Cannot wipe out Project #{name}. Ask the developers."
      return "failure"
    end
    return "success"
  end
end