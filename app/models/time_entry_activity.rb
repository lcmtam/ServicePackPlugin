class TimeEntryActivity < Enumeration
  has_many :TimeEntries, inverse_of: :TimeEntryActivity
  belongs_to :Project
  validate :at_least_one_must_be_active # should be on superclass Enumeration

  def in_use?
    #raise NotImplementedError
    self.time_entries.empty?
  end

  scope :project, ->(id) {where(project_id: id)}
  scope :active, ->{where(active: 1)}

  private
    def at_least_one_must_be_active
      if(!@active)
        if TimeEntryActivity.project(@project_id).active.empty?
          errors[:base] << "Please activate this or other #{self.class.name} in your project"
        end
      end
    end
end