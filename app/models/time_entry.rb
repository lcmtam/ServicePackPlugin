class TimeEntry < ApplicationRecord
  belongs_to :activity, class_name: "TimeEntryActivity", inverse_of: :time_entries,foreign_key: 'activity_id'
  # belongs_to :TimeEntryActivity, -> {where(enumerations: {type: 'TimeEntryActivity'}).includes(:name) }, inverse_of: :TimeEntries,foreign_key: 'activity_id'
  belongs_to :project, inverse_of: :time_entries

  # before_validation: spending, on: :create
  validates :activity_id, presence: true
  validates :project_id, presence: true
  validates :hours, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :comment, length: { maximum: 255}, allow_nil: true
  #validate :activity_project_belong_to_project_id


  private
  	def activity_project_belong_to_project_id
  		if TimeEntryActivity.find(activity_id).project_id != project_id
  			errors[:base] << "Activity does not belong to project specified"
  		end
  	end
end