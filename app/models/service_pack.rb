class ServicePack < ApplicationRecord
  has_many :SPMappings#,  optional: true
  #attr_accessible :name, :capacity

  # only admins can set up a SP

  # before_create: validate_create
 
  validates :name, presence: true, uniqueness: {case_sensitive: false}, length: {maximum: 30}
  validates :capacity, presence: true, numericality: {greater_than_or_equal_to: 0, lesser_than_or_equal_to: 1000000}
  validates :threshold1, presence: true, numericality: {greater_than_or_equal_to: 0, lesser_than_or_equal_to: 100}
  validates :threshold2, presence: true, numericality: {greater_than_or_equal_to: 0, lesser_than_or_equal_to: 100}
  validates :expiration_date, presence: true
  validates :activation_date, presence: true
  validate :must_have_not_been_expired
  validate :no_retroactive_service_pack
  validate :expiration_date_must_be_greater_or_equal
  validate :threshold1_must_be_smaller_than_threshold2
  # should?.validate :used
  
  private

    def must_have_not_been_expired
      if Date.today > expiration_date
        errors.add expiration_date, "must not be in the past."
      end
    end
    def no_retroactive_service_pack
      if Date.today > activation_date
        errors.add activation_date, "must not be in the past."
      end
    end

    def threshold1_must_be_smaller_than_threshold2
      if threshold1 >= threshold2
        errors.add threshold1, "must be smaller than threshold2."
      end
    end

    def expiration_date_must_be_greater_or_equal
      if expiration_date < activation_date
        errors.add expiration_date, "must be greater or equal to activation date."
      end
    end




=begin
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
=end
end