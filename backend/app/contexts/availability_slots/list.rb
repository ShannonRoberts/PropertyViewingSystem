module Contexts
  module AvailabilitySlots
    class List
      def initialize(params)
        @params = params
      end

      def call
        availability_slots = AvailabilitySlot.includes(:property_manager)
        availability_slots = filter_by_property_manager(availability_slots)
        availability_slots = filter_by_date_and_property(availability_slots)
        availability_slots
      end

      private

      attr_reader :params

      def filter_by_property_manager(availability_slots)
        return availability_slots unless params[:property_manager_id].present?

        availability_slots.where(property_manager_id: params[:property_manager_id])
      end

      def filter_by_date_and_property(availability_slots)
        return availability_slots unless params[:date].present? && params[:property_id].present?

        date = parse_date
        return availability_slots unless date

        booked_slots = find_booked_slots(date)
        date_day_name = date.strftime('%A')

        # Filter by property and remove conflicting slots
        availability_slots = availability_slots.where(property_id: params[:property_id])
        availability_slots.reject do |slot|
          slot_conflicts_with_bookings?(slot, date_day_name, booked_slots)
        end
      end

      def parse_date
        Date.parse(params[:date])
      rescue StandardError
        nil
      end

      def find_booked_slots(date)
        # I dont think this is working as intended yet. i think there could be a difference in the date format so the scheduled at is not matching
        Viewing.where(
          property_id: params[:property_id],
          scheduled_at: date.beginning_of_day..date.end_of_day
        ).pluck(:start_time, :end_time)
      end

      def slot_conflicts_with_bookings?(slot, date_day_name, booked_slots)
        slot.day_of_week != date_day_name ||
          booked_slots.any? do |start_time, end_time|
            slot.start_time == start_time && slot.end_time == end_time
          end
      end
    end
  end
end
