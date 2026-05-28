class MaintenanceRecord < ApplicationRecord
  belongs_to :equipment

  validates :description, presence: true
  validates :performed_at, presence: true
  validate :performed_at_not_in_future

  private

  def performed_at_not_in_future
    return if performed_at.blank?
    if performed_at > Time.current
      errors.add(:performed_at, "cannot be in the future")
    end
  end
end
