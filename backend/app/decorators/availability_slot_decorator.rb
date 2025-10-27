class AvailabilitySlotDecorator
  def initialize(availability_slot)
    @availability_slot = availability_slot
  end

  def to_json
    {
      id: @availability_slot.id,
      property_id: @availability_slot.property_id,
      property_manager_id: @availability_slot.property_manager_id,
      start_time: @availability_slot.start_time,
      end_time: @availability_slot.end_time,
      duration_in_minutes: @availability_slot.duration_in_minutes,
      day_of_week: @availability_slot.day_of_week,
      available: @availability_slot.is_available,
      property: property_json,
      property_manager: property_manager_json,
      created_at: @availability_slot.created_at,
      updated_at: @availability_slot.updated_at
    }
  end

  private

  def property_json
    {
      id: @availability_slot.property.id,
      title: @availability_slot.property.title,
      address: @availability_slot.property.full_address
    }
  end

  def property_manager_json
    {
      id: @availability_slot.property_manager.id,
      name: @availability_slot.property_manager.name,
      email: @availability_slot.property_manager.email
    }
  end
end
