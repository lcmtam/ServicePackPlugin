class ServicePack < ApplicationRecord
  has_many: :SPMappings, inverse_of: 'SPMapping'
  has_one: :Project, :through :SPAssign
  attr_accessible :name, :capacity, :expiration_date

  # only admins can set up a SP

  before_create: validate_create
 
  validates :name, presence: true, uniqueness: {case_sensitive: false}, length: {maximum: 30}
  validates :capacity, presence: true, numericality: {greater_than_or_equal_to: 0}
  # should?.validate :used
  
  private

    def validate_save
      if Date.today > expiration_date
        errors.add expiration_date, "must not be in the past."
      end
    end

    def set_in
      used = 0
    end

    def validate_date
      # need to think a bit more clearly
      if Date.today > expiration_date 
        errors.add_to_base "Service Pack #{@id} expires in the past."
      # also must not modify deactivation_date
      elsif deactivation_date && Date.today > deactivation_date
        errors.add_to_base "Service Pack #{@id} is used up."
      end
    end

    def validate_units_left
      if !used && used >= capacity
        errors.add_to_base "Service Pack #{@id} has been used up."
        deactivation_date ||= Date.today
      end
    end
  end