class Enumeration < ApplicationRecord
  belongs_to :project, optional: true
  #validates :project, allow_blank: true # validation of belongs_to is optional
  validates :name, presence: true, uniqueness: {scope: :project, message: "must be unique per project"}, length: {maximum: 30, message: "Name too long! 30 chars max"}
  #validates :project_id, allow_nil: true

  # this is OP
  
  def in_use?
    nil # Enumeration is an abstract class
  end

  private

end