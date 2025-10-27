class PropertyManager < ApplicationRecord
  has_many :availability_slots, dependent: :destroy
  has_many :properties, dependent: :destroy
  has_many :viewings, through: :properties

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true

  before_save { self.email = email.downcase if email.present? }
end
