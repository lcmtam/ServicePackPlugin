class Enumeration < ApplicationRecord
  belongs_to :projects, optional: true # validation of belongs_to is optional
  validates :name, presence: true, uniqueness: {scope: :Project, message: "Name must be unique per project"}, length: {maximum: 30, message: "Name too long! 30 chars max"}
  #validates :project_id, allow_nil: true

  # this is OP
  
  def in_use?
    nil # Enumeration is an abstract class
  end

  private

end