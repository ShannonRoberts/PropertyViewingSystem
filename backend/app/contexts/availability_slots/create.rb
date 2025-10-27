module Contexts
  module AvailabilitySlots
    class Create
      def initialize(params)
        @params = params
      end

      def call
        created_slots = []
        errors = []

        property_ids.each do |prop_id|
          days.each do |day|
            time_slots.each do |slot|
              result = create_single_slot(prop_id, day, slot)

              if result[:success]
                created_slots << result[:slot]
              else
                errors << build_error_response(prop_id, day, slot, result[:errors])
              end
            end
          end
        end

        {
          created_slots: created_slots,
          errors: errors,
          success: errors.empty?
        }
      end

      private

      attr_reader :params

    def create_single_slot(property_id, day, time_slot)
      slot_params = build_slot_params(property_id, day, time_slot)
      availability_slot = AvailabilitySlot.new(slot_params)

      if availability_slot.save
        { success: true, slot: availability_slot }
      else
        { success: false, errors: availability_slot.errors.full_messages }
      end
    end

    def build_slot_params(property_id, day, time_slot)
      {
        property_id: property_id,
        property_manager_id: property_manager_id,
        start_time: time_slot[:start],
        end_time: time_slot[:end],
        is_available: available,
        day_of_week: day
      }
    end

    def build_error_response(property_id, day, slot, error_messages)
      {
        property_id: property_id,
        day_of_week: day,
        slot: slot,
        errors: error_messages
      }
    end

    def days
      params[:selected_days] || []
    end

    def time_slots
      params[:time_slots] || []
    end

    def property_ids
      params[:selected_properties] || []
    end

    def available
      params[:available]
    end

    def property_manager_id
        params[:property_manager_id]
      end
    end
  end
end
