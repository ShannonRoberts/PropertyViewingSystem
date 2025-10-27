class Property < ApplicationRecord
  AVAILABLE = 'Available'.freeze
  UNDER_CONTRACT = 'Under Contract'.freeze
  SOLD = 'Sold'.freeze
  RENTED = 'Rented'.freeze

  PROPERTY_STATUS_VALUES = [
    AVAILABLE,
    UNDER_CONTRACT,
    SOLD,
    RENTED
  ].freeze

  APARTMENT = 'Apartment'.freeze
  HOUSE = 'House'.freeze
  CONDO = 'Condo'.freeze
  TOWNHOUSE = 'Townhouse'.freeze

  PROPERTY_TYPE_VALUES = [
    APARTMENT,
    HOUSE,
    CONDO,
    TOWNHOUSE
  ].freeze

  # Could add image attachments in the future
  # has_many_attached :images
  has_many :viewings, dependent: :destroy
  has_many :potential_tenants, through: :viewings
  has_many :availability_slots, dependent: :destroy
  belongs_to :property_manager

  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :street_address, presence: true
  validates :suburb, presence: true
  validates :city, presence: true
  validates :region, presence: true
  validates :zip_code, presence: true
  validates :country, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :bedrooms, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :bathrooms, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :property_type, presence: true
  validates :status, presence: true
  validate :validate_status
  validate :validate_property_type

  scope :available, -> { where(status: AVAILABLE) }
  scope :by_price_range, ->(min, max) { where(price: min..max) if min.present? && max.present? }
  scope :by_bedrooms, ->(bedrooms) { where(bedrooms: bedrooms) if bedrooms.present? }
  scope :by_property_type, ->(type) { where(property_type: type) if type.present? }
  scope :by_suburb, ->(suburb) { where(suburb: suburb) if suburb.present? }
  scope :by_city, ->(city) { where(city: city) if city.present? }
  scope :by_region, ->(region) { where(region: region) if region.present? }


  def formatted_price
    "$#{price.to_s(:delimited)}"
  end

  def full_address
    "#{street_address}, #{suburb}, #{city}, #{region} #{zip_code}"
  end

  def address_with_country
    "#{full_address}, #{country}"
  end

  private

  def validate_status
    errors.add(:status, "is not a valid property status") unless PROPERTY_STATUS_VALUES.include?(status)
  end

  def validate_property_type
    errors.add(:property_type, "is not a valid property type") unless PROPERTY_TYPE_VALUES.include?(property_type)
  end
end
