class TimeEntryActivity < Enumeration
  has_many :time_entries, inverse_of: :TimeEntryActivity
  belongs_to :project, optional: true, default: nil
  # validate :at_least_one_must_be_active # should be on superclass Enumeration

  def in_use?
    #raise NotImplementedError
    self.time_entries.empty?
  end

  scope :project, ->(id) {where(project_id: id)}
  scope :active, ->{where(active: true)}
  scope :shared, ->{where(parent_id: nil)}

  private
    def at_least_one_must_be_active
      if(!active)
        if TimeEntryActivity.project(project_id).active.empty?
          errors[:base] << "Please activate this or other #{self.class.name} in your project"
        end
      end
    end
end