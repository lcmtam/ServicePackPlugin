class Enumeration < ApplicationRecord
  belongs_to :project, optional: true
  # validates :project, allow_blank: true # validation of belongs_to is optional
  validates :name, presence: true, uniqueness: {scope: :project, message: "must be unique per project"}, length: {maximum: 30, message: "Name too long! 30 chars max"}
  validate :activity_must_have_both_parent_and_project_id_or_neither
  # validate :overridden_activity_must_have_no_parent

  # this is OP
  
  def in_use?
    nil # Enumeration is an abstract class
  end

  private
  	def activity_must_have_both_parent_and_project_id_or_neither
  		if parent_id.nil?
  			if !project_id.nil?
  				errors[:base] << "System activities must not link to any Project"
  			end
		else
			if project_id.nil?
  				errors[:base] << "Overridden activities must have a Project"
  			end
  		end
  	end
end