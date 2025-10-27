require 'rails_helper'

RSpec.describe AvailabilitySlot, type: :model do
  let(:property) { create(:property) }
  let(:property_manager) { create(:property_manager) }

  let(:valid_attributes) do
    {
      property: property,
      property_manager: property_manager,
      start_time: Time.parse('09:00'),
      end_time: Time.parse('10:00'),
      day_of_week: 'Monday',
      is_available: true
    }
  end

  describe 'associations' do
    it { should belong_to(:property) }
    it { should belong_to(:property_manager) }
  end

  describe 'validations' do
    describe 'presence validations' do
      it { should validate_presence_of(:start_time) }
      it { should validate_presence_of(:end_time) }
    end

    describe 'inclusion validations' do
      it { should validate_inclusion_of(:day_of_week).in_array(AvailabilitySlot::DAYS_OF_WEEK) }

      # Test boolean field behavior instead of inclusion
      it 'allows true and false values for is_available' do
        slot_true = AvailabilitySlot.new(valid_attributes.merge(is_available: true))
        slot_false = AvailabilitySlot.new(valid_attributes.merge(is_available: false))
        expect(slot_true).to be_valid
        expect(slot_false).to be_valid
      end
    end

    describe 'custom validations' do
      describe '#end_time_after_start_time' do
        it 'is valid when end_time is after start_time' do
          slot = AvailabilitySlot.new(valid_attributes)
          expect(slot).to be_valid
        end

        it 'is invalid when end_time is before start_time' do
          slot = AvailabilitySlot.new(valid_attributes.merge(
            start_time: Time.parse('10:00'),
            end_time: Time.parse('09:00')
          ))
          expect(slot).not_to be_valid
          expect(slot.errors[:end_time]).to include('must be after start time')
        end

        it 'is invalid when end_time equals start_time' do
          time = Time.parse('09:00')
          slot = AvailabilitySlot.new(valid_attributes.merge(
            start_time: time,
            end_time: time
          ))
          expect(slot).not_to be_valid
          expect(slot.errors[:end_time]).to include('must be after start time')
        end
      end

      describe '#no_overlapping_slots' do
        let!(:existing_slot) do
          AvailabilitySlot.create!(valid_attributes.merge(
            start_time: Time.parse('09:00'),
            end_time: Time.parse('11:00')
          ))
        end

        it 'is invalid when completely overlapping with existing slot' do
          overlapping_slot = AvailabilitySlot.new(valid_attributes.merge(
            start_time: Time.parse('09:30'),
            end_time: Time.parse('10:30')
          ))
          expect(overlapping_slot).not_to be_valid
          expect(overlapping_slot.errors[:base]).to include('This time slot overlaps with an existing availability slot')
        end

        it 'is invalid when start_time is within existing slot' do
          overlapping_slot = AvailabilitySlot.new(valid_attributes.merge(
            start_time: Time.parse('10:00'),
            end_time: Time.parse('12:00')
          ))
          expect(overlapping_slot).not_to be_valid
          expect(overlapping_slot.errors[:base]).to include('This time slot overlaps with an existing availability slot')
        end

        it 'is invalid when end_time is within existing slot' do
          overlapping_slot = AvailabilitySlot.new(valid_attributes.merge(
            start_time: Time.parse('08:00'),
            end_time: Time.parse('10:00')
          ))
          expect(overlapping_slot).not_to be_valid
          expect(overlapping_slot.errors[:base]).to include('This time slot overlaps with an existing availability slot')
        end

        it 'is invalid when completely containing existing slot' do
          overlapping_slot = AvailabilitySlot.new(valid_attributes.merge(
            start_time: Time.parse('08:00'),
            end_time: Time.parse('12:00')
          ))
          expect(overlapping_slot).not_to be_valid
          expect(overlapping_slot.errors[:base]).to include('This time slot overlaps with an existing availability slot')
        end

        it 'is valid when not overlapping (before existing slot)' do
          non_overlapping_slot = AvailabilitySlot.new(valid_attributes.merge(
            start_time: Time.parse('07:00'),
            end_time: Time.parse('08:00')
          ))
          expect(non_overlapping_slot).to be_valid
        end

        it 'is valid when not overlapping (after existing slot)' do
          non_overlapping_slot = AvailabilitySlot.new(valid_attributes.merge(
            start_time: Time.parse('12:00'),
            end_time: Time.parse('13:00')
          ))
          expect(non_overlapping_slot).to be_valid
        end

        it 'is valid when adjacent to existing slot (touching end to start)' do
          adjacent_slot = AvailabilitySlot.new(valid_attributes.merge(
            start_time: Time.parse('11:00'),
            end_time: Time.parse('12:00')
          ))
          expect(adjacent_slot).to be_valid
        end

        it 'is valid when adjacent to existing slot (touching start to end)' do
          adjacent_slot = AvailabilitySlot.new(valid_attributes.merge(
            start_time: Time.parse('08:00'),
            end_time: Time.parse('09:00')
          ))
          expect(adjacent_slot).to be_valid
        end

        it 'allows overlapping slots for different properties' do
          other_property = create(:property)
          non_overlapping_slot = AvailabilitySlot.new(valid_attributes.merge(
            property: other_property,
            start_time: Time.parse('09:30'),
            end_time: Time.parse('10:30')
          ))
          expect(non_overlapping_slot).to be_valid
        end

        it 'allows overlapping slots for different property managers' do
          other_property_manager = create(:property_manager)
          non_overlapping_slot = AvailabilitySlot.new(valid_attributes.merge(
            property_manager: other_property_manager,
            start_time: Time.parse('09:30'),
            end_time: Time.parse('10:30')
          ))
          expect(non_overlapping_slot).to be_valid
        end

        it 'allows updating existing slot without overlap error' do
          existing_slot.is_available = false
          expect(existing_slot).to be_valid
          expect { existing_slot.save! }.not_to raise_error
        end
      end
    end
  end

  describe 'scopes' do
    let!(:available_slot) { create(:availability_slot, is_available: true) }
    let!(:unavailable_slot) { create(:availability_slot, is_available: false) }
    let!(:monday_slot) { create(:availability_slot, day_of_week: 'Monday') }
    let!(:tuesday_slot) { create(:availability_slot, day_of_week: 'Tuesday') }

    describe '.available_slots' do
      it 'returns only available slots' do
        expect(AvailabilitySlot.available_slots).to include(available_slot)
        expect(AvailabilitySlot.available_slots).not_to include(unavailable_slot)
      end
    end

    describe '.unavailable_slots' do
      it 'returns only unavailable slots' do
        expect(AvailabilitySlot.unavailable_slots).to include(unavailable_slot)
        expect(AvailabilitySlot.unavailable_slots).not_to include(available_slot)
      end
    end

    describe '.for_day' do
      it 'returns slots for the specified day' do
        expect(AvailabilitySlot.for_day('Monday')).to include(monday_slot)
        expect(AvailabilitySlot.for_day('Monday')).not_to include(tuesday_slot)
      end
    end
  end

  describe 'constants' do
    describe 'DAYS_OF_WEEK' do
      it 'contains all seven days of the week' do
        expected_days = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
        expect(AvailabilitySlot::DAYS_OF_WEEK).to eq(expected_days)
      end
    end
  end

  describe 'instance methods' do
    describe '#duration_in_minutes' do
      it 'calculates duration correctly for 1 hour slot' do
        slot = AvailabilitySlot.new(valid_attributes.merge(
          start_time: Time.parse('09:00'),
          end_time: Time.parse('10:00')
        ))
        expect(slot.duration_in_minutes).to eq(60)
      end

      it 'calculates duration correctly for 30 minute slot' do
        slot = AvailabilitySlot.new(valid_attributes.merge(
          start_time: Time.parse('09:00'),
          end_time: Time.parse('09:30')
        ))
        expect(slot.duration_in_minutes).to eq(30)
      end

      it 'calculates duration correctly for 2 hour slot' do
        slot = AvailabilitySlot.new(valid_attributes.merge(
          start_time: Time.parse('09:00'),
          end_time: Time.parse('11:00')
        ))
        expect(slot.duration_in_minutes).to eq(120)
      end

      it 'handles 15 minute slots' do
        slot = AvailabilitySlot.new(valid_attributes.merge(
          start_time: Time.parse('09:00'),
          end_time: Time.parse('09:15')
        ))
        expect(slot.duration_in_minutes).to eq(15)
      end
    end
  end

  describe 'factory' do
    it 'creates a valid availability slot' do
      slot = build(:availability_slot)
      expect(slot).to be_valid
    end
  end
end
