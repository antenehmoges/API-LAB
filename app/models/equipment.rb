class Equipment < ApplicationRecord
  belongs_to :category
  has_many :maintenance_records, dependent: :destroy

  VALID_STATUSES = %w[available in_use maintenance].freeze
  SERIAL_NUMBER_FORMAT = /\A[A-Z]{3}-\d{3}\z/

  validates :name, presence: true,
                   length: { minimum: 3, message: "must be at least 3 characters" }
  validates :serial_number, presence: true,
                            uniqueness: true,
                            format: { with: SERIAL_NUMBER_FORMAT,
                                      message: "must match format XXX-NNN (e.g. LAP-001)" }
  validates :status, presence: true, inclusion: { in: VALID_STATUSES,
                                                  message: "%{value} is not a valid status. Use: available, in_use, maintenance" }
  validate :name_contains_letter

  private

  def name_contains_letter
    return if name.blank?
    unless name.match?(/[a-zA-Z]/)
      errors.add(:name, "must contain at least one letter")
    end
  end
end
