require 'rails_helper'

RSpec.describe Viewing, type: :model do
  let(:property) { create(:property) }
  let(:potential_tenant) { create(:potential_tenant) }

  let(:valid_attributes) do
    {
      property: property,
      potential_tenant: potential_tenant,
      scheduled_at: 1.day.from_now,
      status: Viewing::SCHEDULED
    }
  end

  describe 'associations' do
    it { should belong_to(:property) }
    it { should belong_to(:potential_tenant) }
  end

  describe 'validations' do
    describe 'presence validations' do
      it { should validate_presence_of(:scheduled_at) }
      it { should validate_presence_of(:status) }
    end

    describe 'custom validations' do
      describe '#scheduled_at_in_future' do
        context 'when creating a new viewing' do
          it 'is valid when scheduled_at is in the future' do
            viewing = Viewing.new(valid_attributes.merge(scheduled_at: 1.hour.from_now))
            expect(viewing).to be_valid
          end

          it 'is invalid when scheduled_at is in the past for scheduled status' do
            viewing = Viewing.new(valid_attributes.merge(
              scheduled_at: 1.hour.ago,
              status: Viewing::SCHEDULED
            ))
            expect(viewing).not_to be_valid
            expect(viewing.errors[:scheduled_at]).to include('must be in the future')
          end

          it 'is invalid when scheduled_at is current time for scheduled status' do
            current_time = Time.current
            allow(Time).to receive(:current).and_return(current_time)

            viewing = Viewing.new(valid_attributes.merge(
              scheduled_at: current_time,
              status: Viewing::SCHEDULED
            ))
            expect(viewing).not_to be_valid
            expect(viewing.errors[:scheduled_at]).to include('must be in the future')
          end

          it 'allows past scheduled_at for non-scheduled status' do
            viewing = Viewing.new(valid_attributes.merge(
              scheduled_at: 1.hour.ago,
              status: Viewing::COMPLETED
            ))
            expect(viewing).to be_valid
          end
        end

        context 'when updating an existing viewing' do
          let!(:existing_viewing) { create(:viewing, scheduled_at: 1.day.from_now) }

          it 'allows updating other attributes without scheduled_at validation' do
            existing_viewing.status = Viewing::COMPLETED
            expect(existing_viewing).to be_valid
            expect { existing_viewing.save! }.not_to raise_error
          end
        end
      end

      describe '#validate_status' do
        it 'is valid with valid status' do
          viewing = Viewing.new(valid_attributes.merge(status: Viewing::SCHEDULED))
          expect(viewing).to be_valid
        end

        it 'is invalid with invalid status' do
          viewing = Viewing.new(valid_attributes.merge(status: 'Invalid Status'))
          expect(viewing).not_to be_valid
          expect(viewing.errors[:status]).to include('is not a valid viewing status')
        end

        Viewing::VIEWING_STATUS_VALUES.each do |status|
          it "is valid with status #{status}" do
            viewing = Viewing.new(valid_attributes.merge(status: status))
            expect(viewing).to be_valid
          end
        end
      end
    end
  end

  describe 'constants' do
    describe 'VIEWING_STATUS_VALUES' do
      it 'contains all expected status values' do
        expected_statuses = ['Scheduled', 'Completed', 'Cancelled', 'No Show', 'Requested']
        expect(Viewing::VIEWING_STATUS_VALUES).to eq(expected_statuses)
      end
    end
  end

  describe 'scopes' do
    let!(:upcoming_viewing) { create(:viewing, scheduled_at: 1.day.from_now) }
    let!(:past_viewing) { create(:viewing, scheduled_at: 1.day.ago, status: Viewing::COMPLETED) }
    let!(:scheduled_viewing) { create(:viewing, status: Viewing::SCHEDULED) }
    let!(:completed_viewing) { create(:viewing, status: Viewing::COMPLETED) }
    let!(:cancelled_viewing) { create(:viewing, status: Viewing::CANCELLED) }
    let!(:no_show_viewing) { create(:viewing, status: Viewing::NO_SHOW) }
    let!(:requested_viewing) { create(:viewing, status: Viewing::REQUESTED) }

    describe '.upcoming' do
      it 'returns viewings scheduled in the future' do
        expect(Viewing.upcoming).to include(upcoming_viewing)
        expect(Viewing.upcoming).not_to include(past_viewing)
      end
    end

    describe '.past' do
      it 'returns viewings scheduled in the past' do
        expect(Viewing.past).to include(past_viewing)
        expect(Viewing.past).not_to include(upcoming_viewing)
      end
    end

    describe '.scheduled' do
      it 'returns viewings with scheduled status' do
        expect(Viewing.scheduled).to include(scheduled_viewing)
        expect(Viewing.scheduled).not_to include(completed_viewing)
      end
    end

    describe '.completed' do
      it 'returns viewings with completed status' do
        expect(Viewing.completed).to include(completed_viewing)
        expect(Viewing.completed).not_to include(scheduled_viewing)
      end
    end

    describe '.cancelled' do
      it 'returns viewings with cancelled status' do
        expect(Viewing.cancelled).to include(cancelled_viewing)
        expect(Viewing.cancelled).not_to include(scheduled_viewing)
      end
    end

    describe '.no_show' do
      it 'returns viewings with no show status' do
        expect(Viewing.no_show).to include(no_show_viewing)
        expect(Viewing.no_show).not_to include(scheduled_viewing)
      end
    end

    describe '.requested' do
      it 'returns viewings with requested status' do
        expect(Viewing.requested).to include(requested_viewing)
        expect(Viewing.requested).not_to include(scheduled_viewing)
      end
    end
  end

  describe 'edge cases' do
    it 'handles viewings scheduled exactly 1 minute in the future' do
      viewing = Viewing.new(valid_attributes.merge(scheduled_at: 1.minute.from_now))
      expect(viewing).to be_valid
    end

    it 'handles viewings with different time zones' do
      # Test with a specific timezone
      scheduled_time = Time.zone.parse('2024-12-01 15:00:00')
      viewing = Viewing.new(valid_attributes.merge(scheduled_at: scheduled_time))

      if scheduled_time > Time.current
        expect(viewing).to be_valid
      else
        expect(viewing).not_to be_valid
      end
    end

    it 'allows multiple viewings for the same property at different times' do
      viewing1 = create(:viewing, property: property, scheduled_at: 1.day.from_now)
      viewing2 = Viewing.new(valid_attributes.merge(
        property: property,
        scheduled_at: 2.days.from_now
      ))
      expect(viewing2).to be_valid
    end

    it 'allows multiple viewings for the same tenant at different times' do
      viewing1 = create(:viewing, potential_tenant: potential_tenant, scheduled_at: 1.day.from_now)
      viewing2 = Viewing.new(valid_attributes.merge(
        potential_tenant: potential_tenant,
        scheduled_at: 2.days.from_now
      ))
      expect(viewing2).to be_valid
    end
  end

  describe 'business logic scenarios' do
    it 'allows changing status from scheduled to completed' do
      viewing = create(:viewing, status: Viewing::SCHEDULED)
      viewing.status = Viewing::COMPLETED
      expect(viewing).to be_valid
    end

    it 'allows changing status from scheduled to cancelled' do
      viewing = create(:viewing, status: Viewing::SCHEDULED)
      viewing.status = Viewing::CANCELLED
      expect(viewing).to be_valid
    end

    it 'allows changing status from scheduled to no show' do
      viewing = create(:viewing, status: Viewing::SCHEDULED)
      viewing.status = Viewing::NO_SHOW
      expect(viewing).to be_valid
    end

    it 'allows changing status from requested to scheduled' do
      viewing = create(:viewing, status: Viewing::REQUESTED)
      viewing.status = Viewing::SCHEDULED
      expect(viewing).to be_valid
    end
  end

  describe 'factory' do
    it 'creates a valid viewing' do
      viewing = build(:viewing)
      expect(viewing).to be_valid
    end
  end
end
