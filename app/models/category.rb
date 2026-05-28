class Category < ApplicationRecord
  has_many :equipment, dependent: :restrict_with_error

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { minimum: 3, message: "must be at least 3 characters" }
end
