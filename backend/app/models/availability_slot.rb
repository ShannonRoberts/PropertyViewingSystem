class AvailabilitySlot < ApplicationRecord
  DAYS_OF_WEEK = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze

  belongs_to :property
  belongs_to :property_manager

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :day_of_week, inclusion: { in: DAYS_OF_WEEK }
  validates :is_available, inclusion: { in: [true, false] }
  validate :end_time_after_start_time
  validate :no_overlapping_slots

  scope :available_slots, -> { where(is_available: true) }
  scope :unavailable_slots, -> { where(is_available: false) }
  scope :for_day, ->(day) { where(day_of_week: day) }

  def duration_in_minutes
    ((end_time - start_time) / 1.minute).round
  end

  private

  def end_time_after_start_time
    return unless start_time && end_time

    errors.add(:end_time, "must be after start time") if end_time <= start_time
  end

  def no_overlapping_slots
    return unless start_time && end_time && property_id && property_manager_id

    overlapping = AvailabilitySlot.where(
      property_id: property_id,
      property_manager_id: property_manager_id
    ).where.not(id: id)
    .where(
      '(start_time < ? AND end_time > ?) OR (start_time < ? AND end_time > ?)',
      end_time, start_time, start_time, end_time
    )

    errors.add(:base, "This time slot overlaps with an existing availability slot") if overlapping.exists?
  end
end
