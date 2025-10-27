class Viewing < ApplicationRecord
  SCHEDULED = 'Scheduled'.freeze
  COMPLETED = 'Completed'.freeze
  CANCELLED = 'Cancelled'.freeze
  NO_SHOW = 'No Show'.freeze
  REQUESTED = 'Requested'.freeze

  VIEWING_STATUS_VALUES = [
    SCHEDULED,
    COMPLETED,
    CANCELLED,
    NO_SHOW,
    REQUESTED
  ].freeze

  belongs_to :property
  belongs_to :potential_tenant

  validates :scheduled_at, presence: true
  validates :status, presence: true
  validate :scheduled_at_in_future, on: :create
  validate :validate_status

  scope :upcoming, -> { where('scheduled_at > ?', Time.current) }
  scope :past, -> { where('scheduled_at < ?', Time.current) }
  scope :scheduled, -> { where(status: SCHEDULED) }
  scope :completed, -> { where(status: COMPLETED) }
  scope :cancelled, -> { where(status: CANCELLED) }
  scope :no_show, -> { where(status: NO_SHOW) }
  scope :requested, -> { where(status: REQUESTED) }

  private

  def scheduled_at_in_future
    return unless scheduled_at.present? && status == SCHEDULED

    errors.add(:scheduled_at, "must be in the future") if scheduled_at <= Time.current
  end

  def validate_status
    errors.add(:status, "is not a valid viewing status") unless VIEWING_STATUS_VALUES.include?(status)
  end
end
