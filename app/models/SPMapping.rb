class SPMapping < ApplicationRecord
  belongs_to :service_pack, inverse_of: 'ServicePack'
  belongs_to :activity, class_name 'TimeEntryActivity'

  validate :ServicePack_id, presence: { message: "No Service Pack is assorted" }, uniqueness: { scope :activity_id }
  validate :rate, presence: true, numericality: { greater_than_or_equal_to: 0}
  before_save: validate_activities

  def validate_activities
    # check if belong to project_id
    activity.find_by('activity_id = ?', activity_id).project_id == SPAssign.find_by('service_pack_id = ?', service_pack_id).project_id
  end
end